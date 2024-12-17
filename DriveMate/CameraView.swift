import SwiftUI
import AVFoundation

struct CameraView: View {
   
    @StateObject private var detectionViewModel = ObjectDetectionViewModel()
    @StateObject var cameraManager = CameraManager()
    
    var body: some View {
        ZStack {
            CameraPreview(previewLayer: cameraManager.previewLayer)
                .edgesIgnoringSafeArea(.all)
            
//            VStack {
//                Text("\(detectionViewModel.detectedObjects.count)")
//                    .padding(8)
//                    .background(Color.black.opacity(0.7))
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                Spacer()
//                ForEach(detectionViewModel.detectedObjects) { detection in
//                              Text("\(detection.label): \(String(format: "%.2f", detection.confidence))")
//                                  .padding(8)
//                                  .background(Color.black.opacity(0.7))
//                                  .foregroundColor(.white)
//                                  .cornerRadius(8)
//                          }
//                          .padding(.bottom, 20)
//                      }
            
            ForEach(detectionViewModel.detectedObjects) { detection in
                            BoundingBoxView(boundingBox: detection.boundingBox, label: detection.label)
                        }
            
        }
        .onAppear {
            cameraManager.frameProcessor = detectionViewModel
            cameraManager.startSession()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        if let previewLayer = previewLayer {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Nothing to update yet
    }
}
