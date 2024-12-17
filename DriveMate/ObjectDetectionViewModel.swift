//
//  ObjectDetectionViewModel.swift
//  DriveMate
//
//  Created by MMH on 11/12/24.
//


// ObjectDetectionViewModel.swift: Handles CoreML model inference
import CoreML
import Vision

class ObjectDetectionViewModel: ObservableObject, FrameProcessProtocol {
    @Published var detectedObjects: [DetectedObject] = []
    private var detectionRequest: VNCoreMLRequest?

    init() {
        configureModel()
    }

    private func configureModel() {
        guard let model = try? VNCoreMLModel(for: yolo11n(configuration: .init()).model) else { return }
        model.featureProvider = ThresholdProvider(iouThreshold: 0.3, confidenceThreshold: 0.45)
        detectionRequest = VNCoreMLRequest(model: model) { [weak self] request, _ in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            self?.processDetections(results)
            self?.detectionRequest?.imageCropAndScaleOption = .scaleFill
        }
    }

    func processFrame(_ frameBuffer: CVPixelBuffer) {
        guard let request = detectionRequest else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: frameBuffer, orientation: .up, options: [:])
        try? handler.perform([request])
    }

    private func processDetections(_ observations: [VNRecognizedObjectObservation]) {
        let detections = observations.map { observation -> DetectedObject in
                let boundingBox = observation.boundingBox
                let label = observation.labels.first?.identifier ?? "Unknown"
                let confidence = observation.labels.first?.confidence ?? 0.0
                
                return DetectedObject(label: label, confidence: confidence, boundingBox: boundingBox)
            }

        DispatchQueue.main.async { [weak self] in
            self?.detectedObjects = detections
        }
    }
}
