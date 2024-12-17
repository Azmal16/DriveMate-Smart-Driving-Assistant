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

        detectionRequest = VNCoreMLRequest(model: model) { [weak self] request, _ in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            self?.processDetections(results)
        }
    }

    func processFrame(_ frameBuffer: CVPixelBuffer) {
        guard let request = detectionRequest else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: frameBuffer, orientation: .up, options: [:])
        try? handler.perform([request])
    }

    private func processDetections(_ observations: [VNRecognizedObjectObservation]) {
        let detections = observations.compactMap { observation -> DetectedObject?  in
            guard let topLabel = observation.labels.first else { return nil }
            return DetectedObject(label: topLabel.identifier, confidence: topLabel.confidence)
        }

        DispatchQueue.main.async { [weak self] in
            self?.detectedObjects = detections
        }
    }
}
