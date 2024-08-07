#import "LibNativeBridge.h"
#import <Babylon/AppRuntime.h>
#import <Babylon/Graphics/Device.h>
#import <Babylon/ScriptLoader.h>
#import <Babylon/Plugins/NativeEngine.h>
#import <Babylon/Plugins/NativeInput.h>
#import <Babylon/Plugins/NativeOptimizations.h>
#import <Babylon/Plugins/NativeXr.h>
#import <Babylon/Polyfills/Canvas.h>
#import <Babylon/Polyfills/Console.h>
#import <Babylon/Polyfills/Window.h>
#import <Babylon/Polyfills/XMLHttpRequest.h>


#define UNUSED_PARAMETER(param)     (void)(param)

std::optional<Babylon::Graphics::Device> device{};
std::optional<Babylon::Graphics::DeviceUpdate> update{};
std::optional<Babylon::AppRuntime> runtime{};
std::optional<Babylon::Polyfills::Canvas> nativeCanvas{};
std::optional<Babylon::Plugins::NativeXr> nativeXr{};
Babylon::Plugins::NativeInput* nativeInput{};
bool isXrActive{};

@implementation LibNativeBridge {
  bool m_initialized;
}

- (instancetype)init:(UIView*)inView
{
  if (self = [super init]) {
    _m_metalView = inView;
    _metalLayer = (CAMetalLayer*)inView.layer;
  }
  return self;
}


- (void)setM_layerRenderer:(cp_layer_renderer_t)m_layerRenderer {
  _m_layerRenderer = m_layerRenderer;
//  runtime->Dispatch([self](Napi::Env env) {
//    UNUSED_PARAMETER(env);
//    nativeXr->UpdateWindow((__bridge void*)_m_layerRenderer);
//  });
}

- (bool)initialize {
  if (m_initialized) {
    return true;
  }
  
  Babylon::Graphics::Configuration graphicsConfig{};
  graphicsConfig.Window = _m_layerRenderer;
  // Pass in visionOS default widht and height.
#if TARGET_OS_SIMULATOR
  graphicsConfig.Width = static_cast<size_t>(2732);
  graphicsConfig.Height = static_cast<size_t>(2048);
#else
  //  graphicsConfig.Width = static_cast<size_t>(1920);
  //  graphicsConfig.Height = static_cast<size_t>(1824);
  graphicsConfig.Width = static_cast<size_t>(1000);
  graphicsConfig.Height = static_cast<size_t>(600);
#endif
  
  device.emplace(graphicsConfig);
  update.emplace(device->GetUpdate("update"));
  
  device->StartRenderingCurrentFrame();
  update->Start();
  
  runtime.emplace();
  
  runtime->Dispatch([&self](Napi::Env env)
                    {
    device->AddToJavaScript(env);
    
    Babylon::Polyfills::Console::Initialize(env, [](const char* message, auto) {
      NSLog(@"%s", message);
    });
    
    nativeCanvas.emplace(Babylon::Polyfills::Canvas::Initialize(env));
    
    Babylon::Polyfills::Window::Initialize(env);
    
    Babylon::Polyfills::XMLHttpRequest::Initialize(env);
    
    Babylon::Plugins::NativeEngine::Initialize(env);
    
    Babylon::Plugins::NativeOptimizations::Initialize(env);
    
    nativeXr.emplace(Babylon::Plugins::NativeXr::Initialize(env));
    
    nativeXr->SetSessionStateChangedCallback([](bool isXrActive){
      // Enter immersive space here
      if (isXrActive) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChanged" object:nil];
      } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChanged" object:nil, userInfo: @{@"state"}];
      }
    });
    nativeXr->UpdateWindow((__bridge void*)_m_layerRenderer);
    
    nativeInput = &Babylon::Plugins::NativeInput::CreateForJavaScript(env);
  });
  
  Babylon::ScriptLoader loader{ *runtime };
  loader.LoadScript("app:///Scripts/ammo.js");
  loader.LoadScript("app:///Scripts/recast.js");
  loader.LoadScript("app:///Scripts/babylon.max.js");
  loader.LoadScript("app:///Scripts/babylonjs.loaders.js");
  loader.LoadScript("app:///Scripts/babylonjs.materials.js");
  loader.LoadScript("app:///Scripts/babylon.gui.js");
  loader.LoadScript("app:///Scripts/experience.js");
  m_initialized = true;
  
  return true;
}

- (void)render {
  if (device && m_initialized)
  {
    update->Finish();
    device->FinishRenderingCurrentFrame();
    device->StartRenderingCurrentFrame();
    update->Start();
  }
}

- (void)shutdown {
  if (!m_initialized) {
    return;
  }
  
  if (device)
  {
    update->Finish();
    device->FinishRenderingCurrentFrame();
  }
  
  nativeInput = {};
  nativeCanvas.reset();
  runtime.reset();
  update.reset();
  device.reset();
  m_initialized = false;
}


- (void)setTouchDown:(int)pointerId x:(int)inX y:(int)inY
{
    if (nativeInput != nullptr) {
        nativeInput->TouchDown(pointerId, inX, inY);
    }
}

- (void)setTouchMove:(int)pointerId x:(int)inX y:(int)inY
{
    if (nativeInput != nullptr) {
        nativeInput->TouchMove(pointerId, inX, inY);
    }
}

- (void)setTouchUp:(int)pointerId x:(int)inX y:(int)inY
{
    if (nativeInput != nullptr) {
        nativeInput->TouchUp(pointerId, inX, inY);
    }
}

- (bool)isXRActive {
  return false;
}


@end

//bool LibNativeBridge::initialize() {
//  if (m_initialized) {
//    return true;
//  }
//
//  Babylon::Graphics::Configuration graphicsConfig{};
//  graphicsConfig.Window = (CAMetalLayer*)metalView.layer;
//  // Pass in visionOS default widht and height.
//#if TARGET_OS_SIMULATOR
//  graphicsConfig.Width = static_cast<size_t>(2732);
//  graphicsConfig.Height = static_cast<size_t>(2048);
//#else
////  graphicsConfig.Width = static_cast<size_t>(1920);
////  graphicsConfig.Height = static_cast<size_t>(1824);
//  graphicsConfig.Width = static_cast<size_t>(1000);
//  graphicsConfig.Height = static_cast<size_t>(600);
//#endif
//
//  device.emplace(graphicsConfig);
//  update.emplace(device->GetUpdate("update"));
//
//  device->StartRenderingCurrentFrame();
//  update->Start();
//
//  runtime.emplace();
//
//  runtime->Dispatch([](Napi::Env env)
//  {
//      device->AddToJavaScript(env);
//
//      Babylon::Polyfills::Console::Initialize(env, [](const char* message, auto) {
//          NSLog(@"%s", message);
//      });
//
//      nativeCanvas.emplace(Babylon::Polyfills::Canvas::Initialize(env));
//
//      Babylon::Polyfills::Window::Initialize(env);
//
//      Babylon::Polyfills::XMLHttpRequest::Initialize(env);
//
//      Babylon::Plugins::NativeEngine::Initialize(env);
//
//      Babylon::Plugins::NativeOptimizations::Initialize(env);
//
////      nativeXr.emplace(Babylon::Plugins::NativeXr::Initialize(env));
////      nativeXr->UpdateWindow((__bridge void*)m_layerRenderer);
////      nativeXr->SetSessionStateChangedCallback([](bool isXrActive){
////        // Enter immersive space here
////        if (isXrActive) {
////
////        }
////      });
//
//      nativeInput = &Babylon::Plugins::NativeInput::CreateForJavaScript(env);
//  });
//
//  Babylon::ScriptLoader loader{ *runtime };
//  loader.LoadScript("app:///Scripts/ammo.js");
//  loader.LoadScript("app:///Scripts/recast.js");
//  loader.LoadScript("app:///Scripts/babylon.max.js");
//  loader.LoadScript("app:///Scripts/babylonjs.loaders.js");
//  loader.LoadScript("app:///Scripts/babylonjs.materials.js");
//  loader.LoadScript("app:///Scripts/babylon.gui.js");
//  loader.LoadScript("app:///Scripts/experience.js");
//  m_initialized = true;
//
//  return true;
//}
//
//void LibNativeBridge::render() {
//  if (device && m_initialized)
//  {
//      update->Finish();
//      device->FinishRenderingCurrentFrame();
//      device->StartRenderingCurrentFrame();
//      update->Start();
//  }
//}
//
//void LibNativeBridge::shutdown() {
//  if (!m_initialized) {
//    return;
//  }
//
//  if (device)
//  {
//      update->Finish();
//      device->FinishRenderingCurrentFrame();
//  }
//
//  nativeInput = {};
//  nativeCanvas.reset();
//  runtime.reset();
//  update.reset();
//  device.reset();
//  m_initialized = false;
//}
//
//void LibNativeBridge::setTouchUp(int pointerId, int x, int y)
//{
//  if (nativeInput != nullptr) {
//      nativeInput->TouchUp(pointerId, x, y);
//  }
//}
//
//
//void LibNativeBridge::setTouchDown(int pointerId, int x, int y)
//{
//  if (nativeInput != nullptr) {
//      nativeInput->TouchDown(pointerId, x, y);
//  }
//}
//
//void LibNativeBridge::setTouchMove(int pointerId, int x, int y)
//{
//
//  if (nativeInput != nullptr) {
//      nativeInput->TouchMove(pointerId, x, y);
//  }
//}
