import SwiftUI

struct FrameView: View {
    var image: CGImage?

    var body: some View {
        if let image {
            GeometryReader { geometry in
                Image(image, scale: 1.0, orientation: .up, label: Text("Video feed"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        } else {
            EmptyView()
        }
    }
}
