#import <XR.h>
#import <XRHelpers.h>

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>
#import <CompositorServices/CompositorServices.h>

#import "Include/IXrContextARKit.h"

#if __has_feature(objc_arc)
#   define AR_RETAIN(obj)
#   define AR_RELEASE(obj)
#else
#   define AR_RETAIN(obj)   ar_retain(obj)
#   define AR_RELEASE(obj)  ar_release(obj)
#endif

#define UNUSED_PARAMETER(param)     (void)(param)


// Collection type
struct ARDataProviders
{
    ar_data_providers_t _Nonnull _collection;
    
    /** Wrap exisitng collection of data providers. */
    ARDataProviders(ar_data_providers_t _Nonnull collection)
        : _collection(collection)
    {
    }
    
    /** Creates an empty collection of data providers. */
    ARDataProviders(void)
        : ARDataProviders(ar_data_providers_create())
    {
    }
    
    /** Adds a data provider to a collection. */
    inline void addDataProvider(ar_data_provider_t _Nonnull dataProvider)
    {
        ar_data_providers_add_data_provider(_collection, dataProvider);
    }
    
    /** Adds multiple data providers to a collection. */
    inline void addDataProviders(ar_data_providers_t _Nonnull dataProviders)
    {
        ar_data_providers_add_data_providers(_collection, dataProviders);
    }
    /** Adds multiple data providers to a collection. */
    inline void addDataProviders(const ARDataProviders &dataProviders)
    {
        addDataProviders(dataProviders._collection);
    }
    
    /** Enumerates a collection of data providers. */
    inline void enumerateDataProviders(ar_data_providers_enumerator_t _Nonnull enumerator)
    {
        ar_data_providers_enumerate_data_providers(_collection, enumerator);
    }
    /** Enumerates a collection of data providers. */
    inline void enumerateDataProviders(void *_Nullable context, ar_data_providers_enumerator_function_t _Nonnull enumeratorFunction)
    {
        ar_data_providers_enumerate_data_providers_f(_collection, context, enumeratorFunction);
    }
    
    /** Gets the number of data providers in a collection. */
    inline size_t getCount(void) const
    {
        return ar_data_providers_get_count(_collection);
    }
    
    /** Removes a data provider from a collection. */
    inline void removeDataProvider(ar_data_provider_t _Nonnull providerToRemove)
    {
        ar_data_providers_remove_data_provider(_collection, providerToRemove);
    }
    
    /** Removes multiple data providers from a collection. */
    inline void removeDataProviders(ar_data_providers_t _Nonnull dataProviders)
    {
        ar_data_providers_remove_data_providers(_collection, dataProviders);
    }
    /** Removes multiple data providers from a collection. */
    inline void removeDataProviders(const ARDataProviders &dataProviders)
    {
        removeDataProviders(dataProviders._collection);
    }
};

struct ARSession
{
    ar_session_t _Nullable _session;
    
    /** Wraps an existing session. */
    ARSession(ar_session_t _Nonnull session)
        : _session(session)
    {
        AR_RETAIN(_session);
    }
    
    ARSession(void)
        : _session(nil)
    {
    }
    
    /** Creates a new session. */
    static inline ARSession create()
    {
        return ARSession(ar_session_create());
    }
    
    ~ARSession()
    {
        AR_RELEASE(_session);
    }
    
    inline bool operator!() const
    {
        return nil == _session;
    }

    /** Checks whether the current session is authorized for particular authorization types without requesting authorization. */
    inline void queryAuthorizationResults(ar_authorization_type_t authorizationTypes, ar_authorization_results_handler_t resultsHandler)
    {
        assert(nil != _session);
        ar_session_query_authorization_results(_session, authorizationTypes, resultsHandler);
    }
    /** Checks whether the current session is authorized for particular authorization types without requesting authorization. */
    inline void queryAuthorizationResults(ar_authorization_type_t authorizationTypes, void *_Nullable context, ar_authorization_results_handler_function_t resultsHandlerFunction)
    {
        assert(nil != _session);
        ar_session_query_authorization_results_f(_session, authorizationTypes, context, resultsHandlerFunction);
    }
    
    /** Requests authorization from the user to use the specified kinds of ARKit data. */
    inline void requestAuthorization(ar_authorization_type_t authorizationTypes, ar_authorization_results_handler_t resultsHandler)
    {
        assert(nil != _session);
        ar_session_request_authorization(_session, authorizationTypes, resultsHandler);
    }
    /** Requests authorization from the user to use the specified kinds of ARKit data. */
    inline void requestAuthorization(ar_authorization_type_t authorizationTypes, void *_Nullable context, ar_authorization_results_handler_function_t resultsHandlerFunction)
    {
        assert(nil != _session);
        ar_session_request_authorization_f(_session, authorizationTypes, context, resultsHandlerFunction);
    }
    
    /** Runs a session with the data providers you supply. */
    inline void run(ar_data_providers_t dataProviders)
    {
        assert(nil != _session);
        ar_session_run(_session, dataProviders);
    }
    /** Runs a session with the data providers you supply. */
    inline void run(const ARDataProviders& dataProviders)
    {
        run(dataProviders._collection);
    }

    /** Sets the handler for receiving updates in authorization status for a specific authorization type. */
    inline void setAuthorizationUpdateHandler(dispatch_queue_t _Nullable authorizationUpdateQueue, ar_authorization_update_handler_t _Nullable updateHandler)
    {
        ar_session_set_authorization_update_handler(_session, authorizationUpdateQueue, updateHandler);
    }
    /** Sets the handler for receiving updates in authorization status for a specific authorization type. */
    inline void setAuthorizationUpdateHandler(dispatch_queue_t _Nullable authorizationUpdateQueue, void *_Nullable context, ar_authorization_update_handler_function_t _Nullable updateHandlerFunction)
    {
        ar_session_set_authorization_update_handler_f(_session, authorizationUpdateQueue, context, updateHandlerFunction);
    }
    
    /** Stops a session. */
    inline void stop(void)
    {
        assert(nil != _session);
        ar_session_stop(_session);
    }
};

struct ARDeviceAnchor
{
    ar_device_anchor_t _anchor;
    
    ARDeviceAnchor(ar_device_anchor_t anchor)
        : _anchor(anchor)
    {
    }
    
    ARDeviceAnchor()
        : ARDeviceAnchor(ar_device_anchor_create())
    {
    }
};

// Collection type
struct WorldAnchors
{
    ar_world_anchors_t _Nonnull _collection;
    
    WorldAnchors(ar_world_anchors_t _Nonnull collection)
        : _collection(collection)
    {
    }
    
    /** Enumerates a collection of world anchors. */
    inline void enumerateAnchors(ar_world_anchors_enumerator_t worldAnchorsEnumerator)
    {
        ar_world_anchors_enumerate_anchors(_collection, worldAnchorsEnumerator);
    }
    /** Enumerates a collection of world anchors. */
    inline void enumerateAnchors(void *_Nullable context, ar_world_anchors_enumerator_function_t enumeratorFunction)
    {
        ar_world_anchors_enumerate_anchors_f(_collection, context, enumeratorFunction);
    }

    /** Gets the number of world anchors in the collection. */
    inline size_t getCount() const
    {
        return ar_world_anchors_get_count(_collection);
    }
};

struct WorldTrackingProvider
{
    ar_world_tracking_provider_t _Nullable _provider;
    
    /** Creates a world tracking provider. */
    WorldTrackingProvider(ar_world_tracking_configuration_t configuration)
        : _provider(ar_world_tracking_provider_create(configuration))
    {
        AR_RETAIN(_provider);
    }
    
    /** Creates a world tracking provider. */
    WorldTrackingProvider(void)
        : _provider(nil)
    {
    }
    
    ~WorldTrackingProvider(void)
    {
        AR_RELEASE(_provider);
    }
    
    inline bool operator!() const
    {
        return nil == _provider;
    }

    /** Creates a world tracking provider. */
    static inline WorldTrackingProvider create()
    {
        return WorldTrackingProvider(ar_world_tracking_configuration_create());
    }
    
    /** Returns a bool value that indicates whether the current runtime environment supports world tracking providers. */
    static inline bool isSupported()
    {
        return ar_world_tracking_provider_is_supported();
    }
    
    /** Queries the predicted pose of the currentt device at a given time. */
    inline bool queryDeviceAnchorAtTimestamp(CFTimeInterval timestamp, ar_device_anchor_t deviceAnchor) const
    {
        assert(nil != _provider);
        return ar_world_tracking_provider_query_device_anchor_at_timestamp(_provider, timestamp, deviceAnchor) == ar_device_anchor_query_status_success;
    }
    /** Queries the predicted pose of the currentt device at a given time. */
    inline bool queryDeviceAnchorAtTimestamp(CFTimeInterval timestamp, ARDeviceAnchor &deviceAnchor) const
    {
        return queryDeviceAnchorAtTimestamp(timestamp, deviceAnchor._anchor);
    }

    /** Adds a world anchor you supply to the set of currently tracked anchors. */
    inline void addAnchor(ar_world_anchor_t worldAnchor, ar_world_tracking_add_anchor_completion_handler_t completionHandler)
    {
        assert(nil != _provider);
        ar_world_tracking_provider_add_anchor(_provider, worldAnchor, completionHandler);
    }
    /** Adds a world anchor you supply to the set of currently tracked anchors. */
    inline void addAnchor(ar_world_anchor_t worldAnchor, void *context, ar_world_tracking_add_anchor_completion_handler_function_t _Nonnull completionHandlerFunction)
    {
        assert(nil != _provider);
        ar_world_tracking_provider_add_anchor_f(_provider, worldAnchor, context, completionHandlerFunction);
    }
    
    /** Gets the types of authorizations required to track world anchors. */
    static inline ar_authorization_type_t getRequiredAuthorizationType()
    {
        return ar_world_tracking_provider_get_required_authorization_type();
    }
    
    /** Sets the handler for receiving world tracking updates. */
    inline void setAnchorUpdateHandler(dispatch_queue_t _Nullable updatesQueue, ar_world_tracking_anchor_update_handler_t updateHandler)
    {
        assert(nil != _provider);
        ar_world_tracking_provider_set_anchor_update_handler(_provider, updatesQueue, updateHandler);
    }
    /** Sets the handler for receiving world tracking updates. */
    inline void setAnchorUpdateHandler(dispatch_queue_t _Nullable updatesQueue, void * _Nullable context, ar_world_tracking_anchor_update_handler_function_t _Nullable updateHandlerFunction)
    {
        assert(nil != _provider);
        ar_world_tracking_provider_set_anchor_update_handler_f(_provider, updatesQueue, context, updateHandlerFunction);
    }
    
    /** Removes a world anchor from a world tracking provider based on its ID. */
    inline void removeAnchorWithIdentifier(unsigned char * _Nonnull anchorIdentifier, ar_world_tracking_remove_anchor_completion_handler_t completionHandler)
    {
        assert(nil != _provider);
        ar_world_tracking_provider_remove_anchor_with_identifier(_provider, anchorIdentifier, completionHandler);
    }
    
    /** Removes a world anchor from a world tracking provider. */
    inline void removeAnchor(ar_world_anchor_t _Nonnull worldAnchor, ar_world_tracking_remove_anchor_completion_handler_t completionHandler)
    {
        assert(nil != _provider);
        ar_world_tracking_provider_remove_anchor(_provider, worldAnchor, completionHandler);
    }
    /** Removes a world anchor from a world tracking provider. */
    inline void removeAnchor(ar_world_anchor_t _Nonnull worldAnchor, void *_Nullable context, ar_world_tracking_remove_anchor_completion_handler_function_t _Nonnull completionHandlerFunction)
    {
        assert(nil != _provider);
        ar_world_tracking_provider_remove_anchor_f(_provider, worldAnchor, context, completionHandlerFunction);
    }
    
    inline ar_data_provider_state_t getState(void) const
    {
        assert(nil != _provider);
        return ar_data_provider_get_state(_provider);
    }
};


// --------------------------------------------------------------------------------


// Our non-standard function overload
simd_float4x4 simd_make_float4x4(simd_double4x4 m)
{
    return simd_matrix(simd_make_float4(m.columns[0][0], m.columns[0][1], m.columns[0][2], m.columns[0][3]),
                       simd_make_float4(m.columns[1][0], m.columns[1][1], m.columns[1][2], m.columns[1][3]),
                       simd_make_float4(m.columns[2][0], m.columns[2][1], m.columns[2][2], m.columns[2][3]),
                       simd_make_float4(m.columns[3][0], m.columns[3][1], m.columns[3][2], m.columns[3][3]));
}

#import <Spatial/Spatial.h>
simd_float4x4 makeProjectionMatrixFromTangents(simd_float4 tangents, simd_float2 depthRange, bool reversedDepth)
{
    SPProjectiveTransform3D projTransform = SPProjectiveTransform3DMakeFromTangents(tangents[0], tangents[1],
                                                                                    tangents[2], tangents[3],
                                                                                    depthRange[1], depthRange[0],
                                                                                    reversedDepth);
    return simd_make_float4x4(projTransform.matrix);
}

xr::TextureFormat metalTextureFormatToXr(MTLPixelFormat format)
{
    switch (format)
    {
        case MTLPixelFormatBGRA8Unorm: return xr::TextureFormat::BGRA8_SRGB;
        case MTLPixelFormatRGBA8Unorm_sRGB: return xr::TextureFormat::RGBA8_SRGB;
        case MTLPixelFormatDepth16Unorm: return xr::TextureFormat::D16;
        case MTLPixelFormatDepth32Float_Stencil8: return xr::TextureFormat::D24S8; // HACK
        default: return xr::TextureFormat::RGBA8_SRGB;
    }
}


// ------------------------------------------------------------------------------------------


namespace
{
    /**
     Helper function to convert a transformation matrix into an existing xr::Pose.
     */
    static void TransformToPose(simd_float4x4 transform, xr::Pose& pose)
    {
        // Set orientation.
        auto orientation = simd_quaternion(transform);
        pose.Orientation = {
            orientation.vector.x,
            orientation.vector.y,
            orientation.vector.z,
            orientation.vector.w
        };

        // Set the translation.
        pose.Position = {
            transform.columns[3][0],
            transform.columns[3][1],
            transform.columns[3][2]
        };
    }

    /**
     Helper function to convert a transformation matrix into an xr::Pose.
     */
    static xr::Pose TransformToPose(simd_float4x4 transform)
    {
        xr::Pose pose{};
        TransformToPose(transform, pose);
        return pose;
    }

    /**
     Helper function to convert an xr pose into a transformation matrix.
     */
    static simd_float4x4 PoseToTransform(const xr::Pose& pose)
    {
        auto poseQuaternion = simd_quaternion(pose.Orientation.X, pose.Orientation.Y, pose.Orientation.Z, pose.Orientation.W);
        auto poseTransform = simd_matrix4x4(poseQuaternion);
        poseTransform.columns[3][0] = pose.Position.X;
        poseTransform.columns[3][1] = pose.Position.Y;
        poseTransform.columns[3][2] = pose.Position.Z;
        return poseTransform;
    }
}


// -------------------------------------------------------------------------------- ABOVE IS OBJECTIVE-C, BELOW IS C++


namespace xr
{
    struct XrContextARKit /*: public IXrContextARKit*/
    {
        ARSession Session{};
        WorldTrackingProvider WorldTracking{nullptr};
        cp_layer_renderer_t LayerRenderer{nullptr};
        cp_layer_renderer_configuration_t LayerRendererConfiguration{nullptr};
        cp_layer_renderer_layout LayerRendererLayout;
        
        /* NOTE: There is no direct alternative for ARFrame on visionOS.
         * ARFrame is a video image captured as part of a session with position-tracking information.
         * We can emulate the position-tracking part, but for the camera feed we need visionOS 2.0.
         */
        
        void SetLayerRenderer(cp_layer_renderer_t layerRenderer)
        {
            // Release the previous layerRenderer instance (if applicable)
            if (nil != LayerRenderer)
            {
                AR_RELEASE(LayerRenderer);
                LayerRenderer = nil;
            }
            
            // Set the new layerRenderer
            LayerRenderer = layerRenderer;
            AR_RETAIN(layerRenderer);
            
            // Grab its configuration (if applicable)
            if (nil != layerRenderer)
            {
                LayerRendererConfiguration = cp_layer_renderer_get_configuration(layerRenderer);
                assert(nil != LayerRendererConfiguration);
                LayerRendererLayout = cp_layer_renderer_configuration_get_layout(LayerRendererConfiguration);
            }
        }

        bool IsInitialized() const
        {
            return !!Session && !!WorldTracking && (nil != LayerRenderer);
        }

        virtual ~XrContextARKit() = default;
    };

    struct System::Impl // NOTE(mario): We can use NATIVE APIs here, its for our system-wide "globals"
    {
        std::unique_ptr<XrContextARKit> XrContext{std::make_unique<XrContextARKit>()};

        Impl(const std::string& applicationName)
        {
            UNUSED_PARAMETER(applicationName);
        }

        bool IsInitialized() const
        {
            return XrContext->IsInitialized();
        }

        bool TryInitialize()
        {
            // TODO(mario): As in the OpenXR case, we can try to initalize the "view properties" (like layouts by fetching them from configuration, etc.)
            XrContext->Session = ARSession::create();
            return true;
        }
    };

    struct System::Session::Impl // NOTE(mario): We can use NATIVE APIs here
    {
        const System::Impl& HmdImpl; // NOTE(mario): Renamed to match the name in OpenXR (was SystemImpl before); has `XrSessionContext`
        
        /* NOTE(mario):
         *      `XRSession::GetRenderTargetForEye("left"|"right")` uses `m_sessionState->ActiveViewConfiguration` array!
         *      This array is populated in `NativeXr::Impl::BeginUpdate()` based on the values that we provide in `ActiveFrameViews` (see Frame::PopulateViews()).
         */
        std::vector<Frame::View> ActiveFrameViews{ {} };

        std::vector<Frame::InputSource> InputSources;
        std::vector<FeaturePoint> FeaturePointCloud{};
        std::optional<Space> EyeTrackerSpace{};
        float DepthNearZ{ DEFAULT_DEPTH_NEAR_Z };
        float DepthFarZ{ DEFAULT_DEPTH_FAR_Z };
        
        /* NOTE(mario):
         *      This function is called as a result of calling JavaScript's `XRSystem.requestSession()`
         *      (which gets handled in `NativeXr::Impl::BeginSessionAsync()` and therefore here) and it
         *      SHOULD initialize and start a AR/VR session.
         *      This is the first half of initialization routine,
         *      the other helf is in `WhenReady()` which will finish the async call (resolve the "promise").
         */
        Impl(System::Impl& systemImpl, void* graphicsContext, void* commandQueue, std::function<void*()> windowProvider)
            : HmdImpl(systemImpl)
            , metalDevice{ (__bridge id<MTLDevice>)graphicsContext }
            , commandQueue{ (__bridge id<MTLCommandQueue>)commandQueue }
        {
            // NOTE(mario): There is no windows in visionOS, but Oskar smuggled a LayerRenderer pointer as a window handle.
            void* layerRenderer = windowProvider();
            assert(nullptr != layerRenderer);
            
            // NOTE(mario): OpenXR asserts that the `hmdImpl` is already initialized!
            //              We cannot do it here yet, as the layerRenderer is not initialized (at this moment)
            systemImpl.XrContext->SetLayerRenderer((__bridge cp_layer_renderer_t)layerRenderer);

            // NOTE(mario): OpenXR creates the session by calling `CreateGraphicsBinding()` and then `xrCreateSession()`.
            //              We don't have to really do it, as visionOS works only with Metal.
            StartARSession();
            
            // NOTE(mario): Then it calls `xrCreateReferenceSpace()`. This is a no-op for us.

            // Initializes the renderer and its resources
            InitializeRenderResources();
            
            // NOTE: At the end (here) we should have fully initialized `HmdImpl` instance
        }

        ~Impl()
        {
            if (currentCommandBuffer != nil) {
                [currentCommandBuffer waitUntilCompleted];
            }

            if (ActiveFrameViews[0].ColorTexturePointer != nil) {
                id<MTLTexture> oldColorTexture = (__bridge_transfer id<MTLTexture>)ActiveFrameViews[0].ColorTexturePointer;
                [oldColorTexture setPurgeableState:MTLPurgeableStateEmpty];
                ActiveFrameViews[0].ColorTexturePointer = nil;
            }

            if (ActiveFrameViews[0].DepthTexturePointer != nil) {
                id<MTLTexture> oldDepthTexture = (__bridge_transfer id<MTLTexture>)ActiveFrameViews[0].DepthTexturePointer;
                [oldDepthTexture setPurgeableState:MTLPurgeableStateEmpty];
                ActiveFrameViews[0].DepthTexturePointer = nil;
            }

            CleanupAnchor(nil);
            HmdImpl.XrContext->Session.stop();
        }
        
        /**
         After the ARSession starts, it takes a little time before AR frames become available. This function just makes it easy to roll this into CreateAsync.
         */
        arcana::task<void, std::exception_ptr> WhenReady()
        {
            __block arcana::task_completion_source<void, std::exception_ptr> tcs;
            CFRunLoopRef mainRunLoop = CFRunLoopGetMain();
            const auto intervalInSeconds = 0.033;
            CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent(), intervalInSeconds, 0, 0, ^(CFRunLoopTimerRef timer){
                // NOTE(mario): Docs for visionOS: https://developer.apple.com/documentation/arkit/4131560-ar_world_tracking_provider_set_a
                if (HmdImpl.XrContext->WorldTracking.getState() == ar_data_provider_state_running)
                {
                    CFRunLoopRemoveTimer(mainRunLoop, timer, kCFRunLoopCommonModes);
                    CFRelease(timer);
                    tcs.complete();
                }
            });
            CFRunLoopAddTimer(mainRunLoop, timer, kCFRunLoopCommonModes);
            return tcs.as_task();
        }
        
        void StartARSession() // NOTE(mario): Initializes and runs an ARKit session
        {
            // TODO: [MARIO] Restore the ARSessionConfigurator (builder pattern)
            // Create the ARSession enable plane detection, include scene reconstruction mesh if supported, and disable lighting estimation.
            ARSession& arSession = HmdImpl.XrContext->Session;
            arSession = ARSession::create();
            
            WorldTrackingProvider& worldTracking = HmdImpl.XrContext->WorldTracking;
            worldTracking = WorldTrackingProvider::create();
            
            ARDataProviders arDataProviders;
            if (WorldTrackingProvider::isSupported() && !!worldTracking)
            {
                arDataProviders.addDataProvider(worldTracking._provider);
            }
            
            // TODO: FIXME: Sessions in ARKit require implicit or explicit authorization (BEFORE calling run)!
            
            arSession.run(arDataProviders);
        }
        
        void InitializeRenderResources()
        {
//            // NOTE(mario): This `InitializeRenderResources()` will also call `PopulateSwapchains()` (this will endup calling `xrCreateSwapchain()` from `PopulateSwapchain()`!)
//            id<MTLLibrary> lib = CompileShader(metalDevice, shaderSource);
//            id<MTLFunction> vertexFunction = [lib newFunctionWithName:@"vertexShader"];
//            id<MTLFunction> fragmentFunction = [lib newFunctionWithName:@"fragmentShader"];
//
//            // Create a pipeline state for drawing the final composited texture to the screen.
//            {
//                MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
//                pipelineStateDescriptor.label = @"XR Screen Pipeline";
//                pipelineStateDescriptor.vertexFunction = vertexFunction;
//                pipelineStateDescriptor.fragmentFunction = fragmentFunction;
//                pipelineStateDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
//
//                NSError* error;
//                screenPipelineState = [metalDevice newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
//                if (!screenPipelineState) {
//                    NSLog(@"Failed to create screen pipeline state: %@", error);
//                }
//            }
        }

        // NOTE(mario): This is basically the combined update and rendering loop
        std::unique_ptr<System::Session::Frame> GetNextFrame(bool& shouldEndSession, bool& shouldRestartSession)
        {
            // NOTE(mario): OpenXR just processes the events

            shouldEndSession = sessionEnded;
            shouldRestartSession = false;
            
            // Handle layer renderer states
            cp_layer_renderer_t layerRenderer = HmdImpl.XrContext->LayerRenderer;
            cp_layer_renderer_state layerRendererState = cp_layer_renderer_get_state(layerRenderer);
            switch (layerRendererState)
            {
                case cp_layer_renderer_state_invalidated:
                {
                    shouldEndSession = true; // just clean up resources and leave the session
                    break;
                }
                case cp_layer_renderer_state_paused:
                {
                    /*
                     * We don't know if we will become invalidated or running at this point.
                     * Moreover we cannot just skip this iteration (and return `nullptr`)...
                     *
                     * HACK: For now just wait and assume that it will become "running". In the worst case the frame will fail.
                     */
                    cp_layer_renderer_wait_until_running(layerRenderer);
                    break;
                }
                case cp_layer_renderer_state_running:
                {
                    break; // noop
                }
            }
            
            if (!shouldEndSession)
            {
                return std::make_unique<Frame>(*this);
            } else {
                return nullptr;
            }
        }

        void RequestEndSession()
        {
            // Note the end session has been requested, and respond to the request in the next call to GetNextFrame
            sessionEnded = true;
        }

        void GetHitTestResults(std::vector<HitResult>& filteredResults, xr::Ray offsetRay, xr::HitTestTrackableType trackableTypes) const
        {
            // TODO: Restore implementation after initial testing
            UNUSED_PARAMETER(filteredResults);
            UNUSED_PARAMETER(offsetRay);
            UNUSED_PARAMETER(trackableTypes);
        }

        /**
         Create an ARKit anchor for the given pose.
         */
        xr::Anchor CreateAnchor(Pose pose)
        {
            // Pull out the pose into a float 4x4 transform that is usable by ARKit.
            simd_float4x4 poseTransform = PoseToTransform(pose);

            // Create the anchor and add it to the ARKit session.
            ar_world_anchor_t anchor = ar_world_anchor_create_with_origin_from_anchor_transform(poseTransform);
            WorldTrackingProvider& worldTracking = HmdImpl.XrContext->WorldTracking;
            worldTracking.addAnchor(anchor, ^(ar_world_anchor_t anchor, bool successful, ar_error_t _Nullable error) {
                UNUSED_PARAMETER(anchor);
                UNUSED_PARAMETER(successful);
                UNUSED_PARAMETER(error);
                // TODO: Verify if we should somehow mark the anchor as valid, or maybe add it here (asynchronously)
            });
            nativeAnchors.push_back(anchor);
            
            return { { pose }, (__bridge NativeAnchorPtr)anchor };
        }

        /**
         Declares an ARKit anchor that was created outside the BabylonNative xr system.
         */
        xr::Anchor DeclareAnchor(NativeAnchorPtr anchor)
        {
            const ar_world_anchor_t arAnchor = (__bridge ar_world_anchor_t)anchor;
            nativeAnchors.push_back(arAnchor);
            const simd_float4x4 transform = ar_anchor_get_origin_from_anchor_transform(arAnchor);
            const auto pose{TransformToPose(transform)};
            return { { pose }, anchor };
        }
        
        /**
         For a given anchor update the current pose, and determine if it is still valid.
         */
        void UpdateAnchor(xr::Anchor& anchor)
        {
            // First check if the anchor still exists, if not then mark the anchor as no longer valid.
            ar_world_anchor_t arAnchor = (__bridge ar_world_anchor_t)anchor.NativeAnchor;
            if (nil == arAnchor)
            {
                anchor.IsValid = false;
                return;
            }

            // Then update the anchor's pose based on its transform.
            const simd_float4x4 transform = ar_anchor_get_origin_from_anchor_transform(arAnchor);
            anchor.Space.Pose = TransformToPose(transform);
        }

        /**
         Deletes the ArKit anchor associated with this XR anchor if it still exists.
         */
        void DeleteAnchor(xr::Anchor& anchor)
        {
            // If this anchor has not already been deleted, then remove it from the current AR session,
            // and clean up its state in memory.
            if (nil != anchor.NativeAnchor)
            {
                ar_world_anchor_t arAnchor = (__bridge ar_world_anchor_t)anchor.NativeAnchor;
                anchor.NativeAnchor = nil;

                CleanupAnchor(arAnchor);
            }
        }

        /**
         Deallocates the native ARKit anchor object, and removes it from the anchor list.
         */
        void CleanupAnchor(ar_world_anchor_t arAnchor)
        {
            WorldTrackingProvider& worldTracking = HmdImpl.XrContext->WorldTracking;

            // TODO: It would be great to simplify this function
            
            // Iterate over the list of anchors if arAnchor is nil then clean up all anchors
            // otherwise clean up only the target anchor and return.
            auto anchorIter{nativeAnchors.begin()};
            while (anchorIter != nativeAnchors.end()) {
                if (arAnchor == nil || arAnchor == *anchorIter) {
                    worldTracking.removeAnchor(arAnchor, ^(ar_world_anchor_t world_anchor, bool successful, ar_error_t _Nullable error) {
                        UNUSED_PARAMETER(world_anchor);
                        UNUSED_PARAMETER(successful);
                        UNUSED_PARAMETER(error);
                    });
                    anchorIter = nativeAnchors.erase(anchorIter);

                    if (arAnchor != nil) {
                        return;
                    }
                }
                else {
                    anchorIter++;
                }
            }
        }

        /* NOTE(mario):
         *      If we will return `false` here, then `XRViewerPose` in `NativeXr` will flag
         *      the position as emulated by setting `m_isEmulatedPosition = true;`, making
         *      the JavaScript's `XRViewerPose.emulatedPosition` will return the same value.
         */
        bool IsTracking() const
        {
            WorldTrackingProvider& worldTracking = HmdImpl.XrContext->WorldTracking;
            return worldTracking.getState() == ar_data_provider_state_running;
        }

    private:
        bool sessionEnded{ false };
        id<MTLDevice> metalDevice{};

        id<MTLCommandQueue> commandQueue;
        id<MTLCommandBuffer> currentCommandBuffer;
        std::vector<ar_anchor_t> nativeAnchors{};

        /*
         Helper function to translate a world transform into a hit test result.
         */
        HitResult transformToHitResult(simd_float4x4 transform) const
        {
            HitResult hitResult{};
            TransformToPose(transform, hitResult.Pose);
            return hitResult;
        }
    };

    struct System::Session::Frame::Impl
    {
        Impl(Session::Impl& sessionImpl)
            : sessionImpl{sessionImpl}
        {
        }

        std::vector<MTLViewport> viewports;
        Session::Impl& sessionImpl;
        cp_frame_t frame{nil};
        cp_frame_timing_t frameTiming{nil};
        cp_drawable_t drawable{nil};
        CFTimeInterval predictedDisplayTime;
        bool shouldRender{false};
        
        bool BeginFrame()
        {
            assert (nil == frame);

            cp_layer_renderer_t layerRenderer = sessionImpl.HmdImpl.XrContext->LayerRenderer;
            assert(nil != layerRenderer);

            frame = cp_layer_renderer_query_next_frame(layerRenderer);
            if (nil == frame)
            {
                /*
                 * "The function returns `nil` if the layer is paused, invalidated, or has too many frames already in use."
                 * If this is the case, then: "wait a short time and try again".
                 */
                shouldRender = false;
                return false;
            }
            
            return true;
        }
        
        void BeginUpdate()
        {
            if (nil == frame)
            {
                return; // Valid case when `BeginFrame()` fails
            }

            cp_frame_start_update(frame);
            // TODO(mario): perform frame-independent work (input? update data structures)...
        }
        
        void EndUpdate()
        {
            if (nil == frame)
            {
                return; // Valid case when `BeginFrame()` fails
            }
            
            cp_frame_end_update(frame);
            
            // NOTE(mario): The visionOS example app calls this AFTER calling `frame.endUpdate()`.
            //
            // NOTE(mario): Following block of code can be either here (`EndUpdate()`) or at the begining of `BeginRender()`.
            //
            // NOTE(mario): The predictedTiming has:
            //                  - `optimalInputTime` (start submission time);
            //                  - `presentationTime` (when frame will be displayed);
            //                  - `renderingDeadline` (when we must finish the frame tasks).
            //
            // NOTE(mario): "Don’t call this function after you call `cp_frame_query_drawable` for the specified frame." (if so, then use `cp_drawable_get_frame_timing` on that drawable!)
            frameTiming = cp_frame_predict_timing(frame);
            if (nil == frameTiming)
            {
                /* The function MIGHT return `NULL` if the layer is in the "paused" or "invalidated" state. */
                shouldRender = false;
                return;
            }
            cp_time_wait_until(cp_frame_timing_get_optimal_input_time(frameTiming)); // NOTE(mario): almost like xrWaitFrame(); wait for the best moment to start encoding
        }
        
        void BeginRender() // NOTE(mario): This is analogous to `xrBeginFrame()` -- called prior to the start of frame rendering. The app SHOUD still call it and omit rendering work when it SHOULD NOT render.
        {
            if (nil == frame)
            {
                return; // Valid case when `BeginFrame()` fails
            }

            // NOTE(mario): We CAN call it BEFORE or AFTER querying the frame's drawable. Both cases work on simulator.
            //              The default visionOS project, and the "Drawing fully immersive content using Metal" article calls `startSubmission()` BEFORE querying drawable.
            cp_frame_start_submission(frame);
            
            // NOTE(mario): We MUST call `cp_frame_query_drawable()` before `cp_frame_stop_submission()`, otherwise it will crash with an error!
            drawable = cp_frame_query_drawable(frame);
            if (nil == drawable) {
                /* The function MIGHT return `NULL` if the layer is in the "paused" or "invalidated" state. */
                shouldRender = false;
                return;
            }

            // Predict when this frame will be displayed on screen
            cp_frame_timing_t actualTiming = cp_drawable_get_frame_timing(drawable);
            cp_time_t cpPresentationTime = cp_frame_timing_get_presentation_time(actualTiming);
            predictedDisplayTime = cp_time_to_cf_time_interval(cpPresentationTime);
        }
        
        bool ShouldRender() const
        {
            return shouldRender;
        }
        
        simd_float4x4 PredictViewerPoseTransform() // NOTE(mario): Should be called between our `BeginRender()` and `EndRender()` (needs drawable and predictedDisplayTime); ideally ONCE a frame
        {
            simd_float4x4 headTransform = simd_diagonal_matrix(simd_make_float4(1.0f, 1.0f, 1.0f, 1.0f));
            
            WorldTrackingProvider& worldTracking = sessionImpl.HmdImpl.XrContext->WorldTracking;
            ar_device_anchor_t deviceAnchor = ar_device_anchor_create();
            if (worldTracking.queryDeviceAnchorAtTimestamp(predictedDisplayTime, deviceAnchor))
            {
                headTransform = ar_anchor_get_origin_from_anchor_transform(deviceAnchor);
            } else {
                // TODO: Failed to get the estimated pose for the presentation timestamp...
            }
            
            if (nil != drawable)
            {
                // NOTE(mario): Even if we won't get the deviceAnchor, we can call `setDeviceAnchor()` with `nil`
                cp_drawable_set_device_anchor(drawable, deviceAnchor);
            }

            return headTransform;
        }
        
        void PredictViewerPose(Pose& outPose) // NOTE(mario): Should be called between our `BeginRender()` and `EndRender()` (needs drawable and predictedDisplayTime); ideally ONCE a frame
        {
            simd_float4x4 headTransform = PredictViewerPoseTransform();
            TransformToPose(headTransform, outPose);
        }
        
        void PopulateViews(std::vector<xr::System::Session::Frame::View>& outViews) // NOTE(mario): This should be called between `BeginRender()` and `EndRender()` (ideally right after BeginRender)
        {
            assert(nil != drawable);
            
            const size_t numTextures = cp_drawable_get_texture_count(drawable);
            const simd_float2 depthRange = cp_drawable_get_depth_range(drawable);
            const simd_float4x4 headTransform = PredictViewerPoseTransform();
            
            const size_t numViews = cp_drawable_get_view_count(drawable);
            outViews.resize(numViews);
            viewports.resize(numViews);
            for (size_t viewIndex = 0; viewIndex < numViews; viewIndex++)
            {
                auto& xrView = outViews[viewIndex];
                
                /* NOTE(mario): The View below describes how to render the content:
                 *              "Each view contains information you need to render into the drawable’s textures."
                 */
                cp_view_t view = cp_drawable_get_view(drawable, viewIndex);
                
                // Get the view transform
                simd_float4x4 eyeTransform = cp_view_get_transform(view);
                simd_float4x4 finalViewMatrix = simd_inverse(simd_mul(headTransform, eyeTransform));
                TransformToPose(finalViewMatrix, xrView.Space.Pose);
                
                // Get the projection matrix
                simd_float4 tangents = cp_view_get_tangents(view);
                simd_float4x4 projectionMatrix = makeProjectionMatrixFromTangents(tangents, depthRange, true);
                memcpy(xrView.ProjectionMatrix.data(), projectionMatrix.columns, sizeof(float) * xrView.ProjectionMatrix.size());
                
                // Get the necessary information about the textures associated with current `view`
                cp_view_texture_map_t viewTexture = cp_view_get_view_texture_map(view); // "Call this function to get the size of the view and its location within the texture."
                MTLViewport viewport = cp_view_texture_map_get_viewport(viewTexture);   // NOTE(mario): returns the portion of the texture the view uses to draw its content.
                viewports[viewIndex] = viewport;
                
                /* NOTE(mario): Following line returns "The index of the color or depth texture in the drawable.".
                 *              We can simply forward it to `getColorTexture` and `getDepthTexture` functions.
                 *
                 * IMPORTANT:   If we use array-based textures for drawing, fetch the index using `cp_view_texture_map_get_slice_index()` instead!
                 */
                const size_t textureIndex = cp_view_texture_map_get_texture_index(viewTexture);
                assert(textureIndex < numTextures);
                
                id<MTLTexture> colorTexture = cp_drawable_get_color_texture(drawable, textureIndex);
                xrView.ColorTexturePointer = (__bridge_retained void*)colorTexture;
                xrView.ColorTextureFormat = metalTextureFormatToXr(colorTexture.pixelFormat);
                xrView.ColorTextureSize.Width = colorTexture.width;
                xrView.ColorTextureSize.Height = colorTexture.height;
                xrView.ColorTextureSize.Depth = colorTexture.arrayLength;
                
                id<MTLTexture> depthTexture = cp_drawable_get_depth_texture(drawable, textureIndex);
                xrView.DepthTexturePointer = (__bridge_retained void*)depthTexture;
                xrView.DepthTextureFormat = metalTextureFormatToXr(depthTexture.pixelFormat);
                xrView.DepthTextureSize.Width = depthTexture.width;
                xrView.DepthTextureSize.Height = depthTexture.height;
                xrView.DepthTextureSize.Depth = colorTexture.arrayLength;
                
                xrView.DepthNearZ = depthRange[0];
                xrView.DepthFarZ = depthRange[1];
                
                xrView.RequiresAppClear = true;
                
//                if (sessionImpl.HmdImpl.XrContext->LayerRendererLayout == cp_layer_renderer_layout_layered) {
//                    assert(colorTexture.textureType == MTLTextureType2DArray);
//                    assert(depthTexture.textureType == MTLTextureType2DArray);
//                    // NOTE(mario): Following line returns slice index. This is ment only when the renderer_layout is ".layered".
//                    // TODO: [mario] There is a bug in the function doc-comment, it says its for ".dedicated" (instead of ".layered")
//                    size_t sliceIndex = cp_view_texture_map_get_slice_index(viewTexture);
//                    UNUSED_PARAMETER(sliceIndex); // HACK: temporary workaround until implemented properly
//                }
            }
            
            /* NOTE(mario): Those Views[] that we will populate in this function, will be picked up by `NativeXr::Impl::BeginUpdate()`.
             *              Textures will be created by BGFX using `bgfx::overrideInternal()`.
             */
        }
        
        void RenderViews()
        {
            // TODO: [mario] Before we will start rendering anything, we should query the views (fill/update the `.Views` vector) as OpenXR does... (PopulateViewConfigurationState)
            //       The only issue is that it requires a valid drawable to exist...
            
            if (nil != drawable)
            {
                // TODO: Implement this?
            }
        }

        void EndRender()
        {
            if (nil == frame)
            {
                return; // Valid case when `BeginFrame()` fails
            }

            if (nil != drawable)
            {
                // TODO(mario): A bit more edgy case: drawable can be NULL if `queryDrawable()` in `BeginRender()` failed, hinting that the layer is in "paused" or "invalidated" state.
                //              How should we behave in this case? Should we still call `frame.endSubmisison()` or just completly reject this frame?
                //              The tutorial code will skip calling the `endSubmission()` in such case...
                
                // NOTE(mario): We MUST call present on the drawable BEFORE `cp_frame_end_submission()`, otherwise it will CRASH with an ERROR.
                //              Therefore this function MUST be called in the DrawFrame().
            }
            
            // NOTE(mario): We MUST call `cp_frame_query_drawable()` BEFORE `cp_frame_end_submission()`, otherwise it will CRASH with an ERROR.
            //              This function IS being called in the Frame constructor (see `BeginRender()` function above).
            //
            // NOTE(mario): Interesitingly, even if we DO NOT call `startSubmission()` we WILL get a crash with "too many frames in flight" error, hinting that we forgot to call `endSubmission()`.
            //              Same happens without calling `startSubmission()` nor `queryDrawable()` (nor `startUpdate()` + `endUpdate()`).
            //              This hints us that we MUST call `endSubmission()` after EACH successfull `queryNextFrame()`.
            //
            // NOTE(mario): `endSubmission()` MUST be called ONLY ONCE in a frame, otherwise we will get a crash with "called cp_frame_end_submission() before calling cp_frame_start_submission()"
            cp_frame_end_submission(frame);
        }
        
        void EndFrame()
        {
        }
        
    };

    System::Session::Frame::Frame(Session::Impl& sessionImpl)
        : Views{ sessionImpl.ActiveFrameViews }
        , InputSources{ sessionImpl.InputSources }
        , FeaturePointCloud { sessionImpl.FeaturePointCloud }
        , EyeTrackerSpace{ sessionImpl.EyeTrackerSpace }
        , IsTracking{ sessionImpl.IsTracking() }
        , m_impl{ std::make_unique<System::Session::Frame::Impl>(sessionImpl) }
    {
        // NOTE: All functions below, with a "Begin" or "End" prefix MUST be called each frame
        
        m_impl->BeginFrame();
        {
            m_impl->BeginUpdate();
            {
                // TODO(mario): OpenXR updates the "Scene Understanding" (updated/removed planes and meshes)
                
                // TODO(mario): OpenXR updates the input (manager) here => `InputManager->UpdateFrame()`
            }
            m_impl->EndUpdate();
            
            m_impl->BeginRender();
            
            if (m_impl->ShouldRender())
            {
                // We MUST fill the Views[] array (and make sure that the matrices/poses are filled accordingly!) BEFORE we leave this constructor.
                // Other rendering code will rely on those data to perform a proper rendering...
                m_impl->PopulateViews(Views);
            }
        }
    }

    System::Session::Frame::~Frame()
    {
    }

    void System::Session::Frame::Render()
    {
        // NOTE: All functions below, with a "Begin" or "End" prefix MUST be called each frame
        {
            if (m_impl->ShouldRender())
            {
                m_impl->RenderViews();
            }
            
            m_impl->EndRender();
        }
        m_impl->EndFrame();
    }

    void System::Session::Frame::GetHitTestResults(std::vector<HitResult>& filteredResults, xr::Ray offsetRay, xr::HitTestTrackableType trackableTypes) const
    {
        m_impl->sessionImpl.GetHitTestResults(filteredResults, offsetRay, trackableTypes);
    }

    Anchor System::Session::Frame::CreateAnchor(Pose pose, NativeTrackablePtr) const
    {
        return m_impl->sessionImpl.CreateAnchor(pose);
    }

    Anchor System::Session::Frame::DeclareAnchor(NativeAnchorPtr anchor) const
    {
        return m_impl->sessionImpl.DeclareAnchor(anchor);
    }

    void System::Session::Frame::UpdateAnchor(xr::Anchor& anchor) const
    {
        m_impl->sessionImpl.UpdateAnchor(anchor);
    }

    void System::Session::Frame::DeleteAnchor(xr::Anchor& anchor) const
    {
        m_impl->sessionImpl.DeleteAnchor(anchor);
    }

    System::Session::Frame::SceneObject& System::Session::Frame::GetSceneObjectByID(System::Session::Frame::SceneObject::Identifier) const
    {
        throw std::runtime_error("not implemented");
    }

    System::Session::Frame::Plane& System::Session::Frame::GetPlaneByID(System::Session::Frame::Plane::Identifier planeID) const
    {
        UNUSED_PARAMETER(planeID);
        throw std::runtime_error("not implemented");
    }

    System::Session::Frame::ImageTrackingResult& System::Session::Frame::GetImageTrackingResultByID(System::Session::Frame::ImageTrackingResult::Identifier resultID) const
    {
        UNUSED_PARAMETER(resultID);
        throw std::runtime_error("not implemented");
    }

    System::Session::Frame::Mesh& System::Session::Frame::GetMeshByID(System::Session::Frame::Mesh::Identifier meshID) const
    {
        UNUSED_PARAMETER(meshID);
        throw std::runtime_error("not implemented");
    }

    System::System(const char* appName)
        : m_impl{ std::make_unique<System::Impl>(appName) }
    {
    }

    System::~System()
    {
    }

    bool System::IsInitialized() const
    {
        return m_impl->IsInitialized();
    }

    bool System::TryInitialize()
    {
        return m_impl->TryInitialize();
    }

    arcana::task<bool, std::exception_ptr> System::IsSessionSupportedAsync(SessionType sessionType)
    {
        // Only IMMERSIVE_VR is supported for now.
        return arcana::task_from_result<std::exception_ptr>(sessionType == SessionType::IMMERSIVE_VR && WorldTrackingProvider::isSupported());
    }

    uintptr_t System::GetNativeXrContext()
    {
        return reinterpret_cast<uintptr_t>(m_impl->XrContext.get());
    }

    std::string System::GetNativeXrContextType()
    {
        return "ARKit_visionOS";
    }

    arcana::task<std::shared_ptr<System::Session>, std::exception_ptr> System::Session::CreateAsync(System& system, void* graphicsDevice, void* commandQueue, std::function<void*()> windowProvider)
    {
        /* NOTE(mario):
         *      `NativeXr::Impl::BeginSessionAsync()` will get the `Graphics::DeviceContext` reference
         *      from JavaScript (using `Graphics::DeviceContext::GetFromJavaScript()`...).
         *      Once this "context" is acquired, it will try to initialize the XR system (`m_system.TryInitialize()`).
         *      If everything when fine, then this `xr::System::Session::CreateAsync(m_system, ...)` gets called.
         */
        
        // NOTE(mario): Oskar smuggled the LayerRender as a `window`.
        auto session = std::make_shared<System::Session>(system, graphicsDevice, commandQueue, std::move(windowProvider));
        return session->m_impl->WhenReady().then(arcana::inline_scheduler, arcana::cancellation::none(), [session] {
            return session;
        });
    }

    System::Session::Session(System& system, void* graphicsDevice, void* commandQueue, std::function<void*()> windowProvider)
        : m_impl{ std::make_unique<System::Session::Impl>(*system.m_impl, graphicsDevice, commandQueue, windowProvider) }
    {
    }

    System::Session::~Session()
    {
        // Free textures
    }

    /* NOTE(mario):
     *      Called by `NativeXr::Impl::BeginFrame()` and it has to create a `Frame`.
     *      This function MIGHT be called after the session was requested to end, to "Block and burn frames until XR successfuly shuts down" (see NativeXr.cpp:557)
     */
    std::unique_ptr<System::Session::Frame> System::Session::GetNextFrame(bool& shouldEndSession, bool& shouldRestartSession, std::function<arcana::task<void, std::exception_ptr>(void*)> deletedTextureAsyncCallback)
    {
        UNUSED_PARAMETER(deletedTextureAsyncCallback);
        return m_impl->GetNextFrame(shouldEndSession, shouldRestartSession);
    }

    void System::Session::RequestEndSession()
    {
        m_impl->RequestEndSession();
    }

    void System::Session::SetDepthsNearFar(float depthNear, float depthFar) {
        m_impl->DepthNearZ = depthNear;
        m_impl->DepthFarZ = depthFar;
    }

    void System::Session::SetPlaneDetectionEnabled(bool enabled) const
    {
        UNUSED_PARAMETER(enabled);
        // m_impl->SetPlaneDetectionEnabled(enabled);
    }

    bool System::Session::TrySetPreferredPlaneDetectorOptions(const GeometryDetectorOptions&)
    {
        // TODO
        return false;
    }

    bool System::Session::TrySetMeshDetectorEnabled(const bool enabled) // FIXME: [mario] The `const` on value type here does not make much sense, it's a copy...
    {
        UNUSED_PARAMETER(enabled);
        return false;
    }

    bool System::Session::TrySetPreferredMeshDetectorOptions(const GeometryDetectorOptions&)
    {
        // TODO
        return false;
    }

    std::vector<ImageTrackingScore>* System::Session::GetImageTrackingScores() const
    {
        throw std::runtime_error("not implemented");
    }

    void System::Session::CreateAugmentedImageDatabase(const std::vector<System::Session::ImageTrackingRequest>& requests) const
    {
        UNUSED_PARAMETER(requests);
        throw std::runtime_error("not implemented");
    }
}
