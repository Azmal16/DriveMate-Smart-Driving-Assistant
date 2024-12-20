import AVFoundation

protocol FrameProcessProtocol: AnyObject {
    func processFrame(_ frameBuffer: CVPixelBuffer)
}

class CameraManager: NSObject, ObservableObject {
    
    private var session: AVCaptureSession?
    private var videoOutput: AVCaptureVideoDataOutput?
    weak var frameProcessor: FrameProcessProtocol?
    @Published var frameBuffer: CVPixelBuffer?
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        self.setupCamera()
    }
    
    private func setupCamera() {
        setupSession()
        if let session = getSession() {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
        }
    }
    
    // Setup the camera session
    func setupSession() {
        session = AVCaptureSession()
        session?.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Failed to access the camera")
            return
        }
        
        if session?.canAddInput(input) ?? false {
            session?.addInput(input)
        }
        
        // Setup video output
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        guard let videoOutput = videoOutput else { return }
        
        if session?.canAddOutput(videoOutput) ?? false {
            session?.addOutput(videoOutput)
        }
    }
    
    // Start the camera session
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            guard let session = self.session else { return }
            if !session.isRunning {
                session.startRunning()
            } else { return }
        }
    }
    
    // Stop the camera session
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            guard let session = self.session else { return }
            if session.isRunning {
                session.stopRunning()
            } else { return }
        }
    }
    
    func getSession() -> AVCaptureSession? {
        return session
    }
}

// Video data output delegate
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Pass the pixelBuffer to the PoseEstimationViewModel for processing
        DispatchQueue.main.async { [weak self] in
            self?.frameBuffer = pixelBuffer
            self?.frameProcessor?.processFrame(pixelBuffer)
        }
    }
}
