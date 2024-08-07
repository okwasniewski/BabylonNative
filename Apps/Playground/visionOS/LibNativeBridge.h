#ifndef BgfxAdapter_hpp
#define BgfxAdapter_hpp

#include <CompositorServices/CompositorServices.h>
#include <ARKit/ARKit.h>


@interface LibNativeBridge : NSObject

@property(nonatomic) cp_layer_renderer_t m_layerRenderer;
@property(nonatomic) UIView* m_metalView;
@property(nonatomic) CAMetalLayer* metalLayer;

- (instancetype)init:(UIView*)inView;
- (void)render;
- (void)shutdown;
- (bool)initialize;
- (void)setTouchDown:(int)pointerId x:(int)inX y:(int)inY;
- (void)setTouchMove:(int)pointerId x:(int)inX y:(int)inY;
- (void)setTouchUp:(int)pointerId x:(int)inX y:(int)inY;
- (bool)isXRActive;

@end


//class LibNativeBridge {
//private:
//  bool m_initialized = false;
//  cp_layer_renderer_t m_layerRenderer = NULL;
//  UIView *metalView = NULL;
//
//public:
//  LibNativeBridge(UIView *_metalView) : metalView(_metalView) {
//  }
//
//  ~LibNativeBridge() {
//    shutdown();
//  }
//  
//  void setLayerRenderer(cp_layer_renderer_t layerRenderer);
//  
//  bool initialize(void);
//  void shutdown(void);
//  void render(void);
//  void setTouchUp(int pointerId, int x, int y);
//  void setTouchDown(int pointerId, int x, int y);
//  void setTouchMove(int pointerId, int x, int y);
//};

#endif /* BgfxAdapter_hpp */
