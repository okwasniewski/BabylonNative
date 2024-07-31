#import "LibNativeBridge.hpp"
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

std::optional<Babylon::Graphics::Device> device{};
std::optional<Babylon::Graphics::DeviceUpdate> update{};
std::optional<Babylon::AppRuntime> runtime{};
std::optional<Babylon::Polyfills::Canvas> nativeCanvas{};
std::optional<Babylon::Plugins::NativeXr> nativeXr{};
Babylon::Plugins::NativeInput* nativeInput{};

bool LibNativeBridge::initialize() {
  if (m_initialized) {
    return true;
  }
  
  Babylon::Graphics::Configuration graphicsConfig{};
  graphicsConfig.Window = m_layerRenderer;
  // Pass in visionOS default widht and height.
#if TARGET_OS_SIMULATOR
  graphicsConfig.Width = static_cast<size_t>(2732);
  graphicsConfig.Height = static_cast<size_t>(2048);
#else
  graphicsConfig.Width = static_cast<size_t>(1920);
  graphicsConfig.Height = static_cast<size_t>(1824);
#endif
  ar_world_tracking_configuration_t config = ar_world_tracking_configuration_create();
  world_tracking = ar_world_tracking_provider_create(config);
  graphicsConfig.WorldTracking = world_tracking;

  device.emplace(graphicsConfig);
  update.emplace(device->GetUpdate("update"));

  device->StartRenderingCurrentFrame();
  update->Start();

  runtime.emplace();

  runtime->Dispatch([this](Napi::Env env)
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
      nativeXr->UpdateWindow((__bridge void*)m_layerRenderer);
          nativeXr->SetSessionStateChangedCallback([](bool isXrActive){
            NSLog(@"XR SESSION IS: %d", isXrActive);
          });
//      nativeXr->SetSessionStateChangedCallback([](bool isXrActive){ ::isXrActive = isXrActive; });

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
  
  runARSession();
  return true;
}

void LibNativeBridge::render() {
  if (device && m_initialized)
  {
      update->Finish();
      device->FinishRenderingCurrentFrame();
      device->StartRenderingCurrentFrame();
      update->Start();
  }
}

void LibNativeBridge::runARSession() {
  ar_session = ar_session_create();
  auto data_providers = ar_data_providers_create_with_data_providers((ar_data_provider_t)world_tracking, NULL);
  ar_session_run(ar_session, data_providers);
}


void LibNativeBridge::shutdown() {
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
