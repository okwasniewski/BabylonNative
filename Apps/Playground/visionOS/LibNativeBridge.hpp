#ifndef BgfxAdapter_hpp
#define BgfxAdapter_hpp

#include <CompositorServices/CompositorServices.h>
#include <ARKit/ARKit.h>

class LibNativeBridge {
private:
  bool m_initialized = false;
  cp_layer_renderer_t m_layerRenderer = NULL;
  ar_world_tracking_provider_t world_tracking = NULL;
  ar_session_t ar_session = NULL;

public:
  LibNativeBridge(cp_layer_renderer_t layerRenderer) : m_layerRenderer(layerRenderer) {
  }

  ~LibNativeBridge() {
    shutdown();
  }
  
  void runARSession(void);
  bool initialize(void);
  void shutdown(void);
  void render(void);
};

#endif /* BgfxAdapter_hpp */
