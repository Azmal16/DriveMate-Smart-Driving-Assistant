//
//  BoundingBoxView.swift
//  DriveMate
//
//  Created by MMH on 17/12/24.
//


import SwiftUI

struct BoundingBoxView: View {
    let boundingBox: CGRect
    let label: String

    var body: some View {
        GeometryReader { geometry in
            let box = CGRect(
                x: boundingBox.minX * geometry.size.width,
                y: (1 - boundingBox.maxY) * geometry.size.height,
                width: boundingBox.width * geometry.size.width,
                height: boundingBox.height * geometry.size.height
            )
            ZStack {
                Rectangle()
                    .path(in: box)
                    .stroke(Color.red, lineWidth: 2)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
                    .background(Color.red.opacity(0.7))
                    .position(x: box.midX, y: box.minY - 10)
            }
        }
    }
}
