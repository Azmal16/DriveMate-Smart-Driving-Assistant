//
//  DetectedObject.swift
//  DriveMate
//
//  Created by MMH on 17/12/24.
//


import Foundation

struct DetectedObject: Identifiable {
    let id: UUID = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect
}
