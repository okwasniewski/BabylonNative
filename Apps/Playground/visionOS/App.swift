import SwiftUI
import CompositorServices
import Foundation

struct ContentStageConfiguration: CompositorLayerConfiguration {
  func makeConfiguration(capabilities: LayerRenderer.Capabilities, configuration: inout LayerRenderer.Configuration) {
    configuration.depthFormat = .depth32Float
    configuration.colorFormat = .bgra8Unorm_srgb
    
    let foveationEnabled = capabilities.supportsFoveation
    configuration.isFoveationEnabled = foveationEnabled
    
    let options: LayerRenderer.Capabilities.SupportedLayoutsOptions = foveationEnabled ? [.foveationEnabled] : []
    let supportedLayouts = capabilities.supportedLayouts(options: options)
    
    configuration.layout = supportedLayouts.contains(.layered) ? .layered : .dedicated
  }
}

class RenderThread {
    private var thread: Thread?
    private var workItems: [(() -> Void)?] = []
    private let workItemsLock = NSLock()
    private let threadStartedSemaphore = DispatchSemaphore(value: 0)
    
    func start() {
        thread = Thread { [weak self] in
            self?.threadMain()
        }
        thread?.name = "RenderThread"
        thread?.start()
        
        // Wait for the thread to start
        threadStartedSemaphore.wait()
    }
    
    private func threadMain() {
        autoreleasepool {
            threadStartedSemaphore.signal()
            
            while !Thread.current.isCancelled {
                autoreleasepool {
                    if let workItem = self.dequeueWorkItem() {
                        workItem()
                    }
                }
                
                Thread.sleep(forTimeInterval: 0.001) // Sleep briefly to prevent busy-waiting
            }
        }
    }
    
    func perform(_ work: @escaping () -> Void) {
        workItemsLock.lock()
        workItems.append(work)
        workItemsLock.unlock()
    }
    
    private func dequeueWorkItem() -> (() -> Void)? {
        workItemsLock.lock()
        defer { workItemsLock.unlock() }
        return workItems.isEmpty ? nil : workItems.removeFirst()
    }
    
    func stop() {
        thread?.cancel()
        thread = nil
    }
}

class Renderer {
  let serialQueue = DispatchQueue(label: "com.example.serialqueue")
  let renderThread = RenderThread()

  var isRenderingImmersive = false

  // Singelton pattern
  static var shared = Renderer()
  var displayLink: CADisplayLink?
  
  var layerRenderer: LayerRenderer?
  var libNativeBridge: LibNativeBridge?
  
  var metalView: UIView? {
    didSet {
      libNativeBridge = LibNativeBridge(metalView)
      
      // Note: Run render loop on the main queue to properly sync with the display.
      self.displayLink = CADisplayLink(target: self, selector: #selector(self.renderMetalLoop))
      self.displayLink?.add(to: .main, forMode: .common)
     
      // Note: Initialize native bridge (BGFX/Babylon) on the dispatch queue.
      renderThread.start()
      renderThread.perform {
        self.libNativeBridge?.initialize()
      }
    }
  }
  
  @objc func renderMetalLoop() {
    
    if (self.isRenderingImmersive) { return }
    // Render on the dispatch queue.
    renderThread.perform {
//      if (isRenderingImmersive)
      Renderer.shared.libNativeBridge?.render()
    }
  }
  
  func setTouchMove(pointerId: Int32, x: Int32, y: Int32) {
    libNativeBridge?.setTouchMove(pointerId, x: x, y: y)
  }
  
  func setTouchDown(pointerId: Int32, x: Int32, y: Int32) {
    libNativeBridge?.setTouchDown(pointerId, x: x, y: y)
  }
  
  func setTouchUp(pointerId: Int32, x: Int32, y: Int32) {
    libNativeBridge?.setTouchUp(pointerId, x: x, y: y)
  }
  
  init() {}
  
  func startRenderLoop() {
//    renderThread.start()
    libNativeBridge = LibNativeBridge(nil)
    let renderThread = Thread {
      self.renderLoop()
    }
    renderThread.start()
  }
  
  
  func renderLoop() {
    guard let layerRenderer, var libNativeBridge else { return }
    libNativeBridge.m_layerRenderer = layerRenderer
    while true {
      if layerRenderer.state == .invalidated {
        print("Layer is invalidated")
       
        isRenderingImmersive = false
        libNativeBridge.shutdown()
        break
      } else if layerRenderer.state == .paused {
        layerRenderer.waitUntilRunning()
        continue
      } else {
        isRenderingImmersive = true
        libNativeBridge.initialize()
        libNativeBridge.render()
      }
    }
  }
}


class MetalView: UIView {
  
  init() {
    super.init(frame: CGRectMake(0, 0, 1000, 600))
    setupMetalLayer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupMetalLayer() {
    self.addGestureRecognizer(
      UIBabylonGestureRecognizer(
        target: self,
        onTouchDown: Renderer.shared.setTouchDown,
        onTouchMove: Renderer.shared.setTouchMove,
        onTouchUp: Renderer.shared.setTouchUp
      )
    )
    metalLayer.pixelFormat = .bgra8Unorm
    metalLayer.framebufferOnly = true
    
    
    updateDrawableSize()
    
    
    Renderer.shared.metalView = self
  }
  
  var metalLayer: CAMetalLayer {
    return layer as! CAMetalLayer
  }
  
  override class var layerClass: AnyClass {
    return CAMetalLayer.self
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateDrawableSize()
  }
  
  private func updateDrawableSize() {
    metalLayer.drawableSize = CGSize(width: 1000, height: 600)
  }
}

struct MetalViewRepresentable: UIViewRepresentable {
  typealias UIViewType = MetalView
  
  func makeUIView(context: Context) -> MetalView {
    MetalView()
  }
  
  func updateUIView(_ uiView: MetalView, context: Context) {
    // Updates the state of the specified view with new information from SwiftUI.
  }
}


class UIBabylonGestureRecognizer: UIGestureRecognizer {
  // Callback for touch down events
  private let _onTouchDown: (Int32, Int32, Int32)->Void
  // Callback for touch movement events
  private let _onTouchMove: (Int32, Int32, Int32)->Void
  // Callback for touch up events
  private let _onTouchUp: (Int32, Int32, Int32)->Void
  // Table to track hashes of active touches
  private var _activeTouchIds: Array<Int> = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
  
  public init(target: Any?, onTouchDown: @escaping(Int32, Int32, Int32)->Void, onTouchMove: @escaping(Int32, Int32, Int32)->Void, onTouchUp: @escaping(Int32, Int32, Int32)->Void) {
    _onTouchDown = onTouchDown
    _onTouchMove = onTouchMove
    _onTouchUp = onTouchUp
    
    super.init(target: target, action: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    
    for touch in touches {
      guard let deviceSlot = _activeTouchIds.firstIndex(of: -1) else { continue }
      _activeTouchIds[deviceSlot] = touch.hash
      let loc = touch.location(in: view)
      
      _onTouchDown(Int32(deviceSlot), Int32(loc.x), Int32(loc.y))
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    
    for touch in touches {
      guard let deviceSlot = _activeTouchIds.firstIndex(of: touch.hash) else { continue }
      let loc = touch.location(in: view)
      
      _onTouchMove(Int32(deviceSlot), Int32(loc.x), Int32(loc.y))
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    
    for touch in touches {
      guard let deviceSlot = _activeTouchIds.firstIndex(of: touch.hash) else { continue }
      let loc = touch.location(in: view)
      
      _onTouchUp(Int32(deviceSlot), Int32(loc.x), Int32(loc.y))
      _activeTouchIds[deviceSlot] = -1
    }
  }
}


@main
struct ExampleApp: App {
  @State private var showImmersiveSpace = false
  @State private var immersiveSpaceIsShown = false
  
  @Environment(\.openImmersiveSpace) var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
  
  var body: some Scene {
    WindowGroup {
      VStack {
        Text("Hey")
//        if (!immersiveSpaceIsShown) {
//          MetalViewRepresentable()
//        }
      }
          .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.bottom),
            contentAlignment: .bottom
          ) {
            VStack {
              Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding()
            }.glassBackgroundEffect()
          }
          .onChange(of: showImmersiveSpace) { newValue in
            Task {
              await openImmersiveSpace(id: "ImmersiveSpace")
              immersiveSpaceIsShown = true
            }
          }
          .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SessionStateChanged"))) { notification in
//            Renderer.shared.isRenderingImmersive = true
//            Renderer.shared.startRenderLoop()
//            Task {
//              if !immersiveSpaceIsShown {
//                switch await openImmersiveSpace(id: "ImmersiveSpace") {
//                case .opened:
//                  immersiveSpaceIsShown = true
//                case .error, .userCancelled:
//                  fallthrough
//                @unknown default:
//                  immersiveSpaceIsShown = false
//                  showImmersiveSpace = false
//                }
//              } else if immersiveSpaceIsShown {
////                await dismissImmersiveSpace()
//                immersiveSpaceIsShown = false
//              }
//            }
          }
    }
    
    ImmersiveSpace(id: "ImmersiveSpace") {
      CompositorLayer(configuration: ContentStageConfiguration()) { layerRenderer in
          Renderer.shared.layerRenderer = layerRenderer
          Renderer.shared.isRenderingImmersive = true
          Renderer.shared.startRenderLoop()
      }
    }.immersionStyle(selection: .constant(.full), in: .full)
  }
}
