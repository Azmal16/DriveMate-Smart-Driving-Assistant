////
////  ContentView.swift
////  DriveMate
////
////  Created by MMH on 11/12/24.
////
//
//// ContentView.swift: Main UI
//import SwiftUI
//import AVKit
//
//struct ContentView: View {
//    @StateObject private var cameraManager = CameraManager()
//    @StateObject private var detectionViewModel = ObjectDetectionViewModel()
//
//    var body: some View {
//        ZStack {
//            CameraView(frameBuffer: $cameraManager.frameBuffer)
//                .edgesIgnoringSafeArea(.all) // Ensure it covers the entire screen
//
//            VStack {
//                Spacer()
//                ForEach(detectionViewModel.detectedObjects, id: \.0) { detection in
//                    Text("\(detection.label): \(String(format: "%.2f", detection.confidence))")
//                        .padding(8)
//                        .background(Color.black.opacity(0.7))
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding(.bottom, 20)
//            }
//        }
//        .onAppear {
//            cameraManager.startCamera()
//        }
//        .onDisappear {
//            cameraManager.stopCamera()
//        }
//        .onChange(of: cameraManager.frameBuffer) { newBuffer in
//            if let buffer = newBuffer {
//                detectionViewModel.performDetection(on: buffer)
//            }
//        }
//    }
//}
//
