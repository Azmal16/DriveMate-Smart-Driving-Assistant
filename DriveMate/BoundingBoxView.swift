import SwiftUI

struct BoundingBoxView: View {
    let boundingBox: CGRect
    let label: String

    var body: some View {
        GeometryReader { geometry in
            // Scale and flip bounding box coordinates
            let scaledBox = CGRect(
                x: boundingBox.minX * geometry.size.width,
                y: (1 - boundingBox.maxY) * geometry.size.height, // Flip Y-axis
                width: boundingBox.width * geometry.size.width,
                height: boundingBox.height * geometry.size.height
            )

            ZStack(alignment: .topLeading) {
                // Draw the bounding box
                Rectangle()
                    .path(in: scaledBox)
                    .stroke(Color.red, lineWidth: 2)

                // Draw the label above the bounding box
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
                    .background(Color.red.opacity(0.7))
                    .position(x: scaledBox.minX + scaledBox.width / 2, y: scaledBox.minY - 10)
            }
        }
    }
}
