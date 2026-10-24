import SwiftUI
import UIKit
import ImageIO

struct AnimatedGIFView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        loadGIF(into: imageView)

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // Animation is loaded when the view is created.
    }

    private func loadGIF(into imageView: UIImageView) {
        var gifData: Data?

        // First, try loading the GIF from an asset data set.
        if let assetData = NSDataAsset(name: name) {
            gifData = assetData.data
        }

        // If it is not a data asset, try the app bundle.
        if gifData == nil,
           let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            gifData = try? Data(contentsOf: url)
        }

        guard let data = gifData,
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Could not load GIF: \(name)")
            return
        }

        var frames: [UIImage] = []
        var totalDuration: TimeInterval = 0

        let frameCount = CGImageSourceGetCount(source)

        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(
                source,
                index,
                nil
            ) else {
                continue
            }

            let properties = CGImageSourceCopyPropertiesAtIndex(
                source,
                index,
                nil
            ) as? [CFString: Any]

            let gifProperties = properties?[kCGImagePropertyGIFDictionary]
                as? [CFString: Any]

            let unclampedDelay = gifProperties?[
                kCGImagePropertyGIFUnclampedDelayTime
            ] as? TimeInterval

            let normalDelay = gifProperties?[
                kCGImagePropertyGIFDelayTime
            ] as? TimeInterval

            let duration = unclampedDelay ?? normalDelay ?? 0.1

            frames.append(UIImage(cgImage: cgImage))
            totalDuration += max(duration, 0.02)
        }

        guard !frames.isEmpty else {
            print("GIF has no readable frames: \(name)")
            return
        }

        imageView.animationImages = frames
        imageView.animationDuration = max(totalDuration, 0.1)
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
}

#Preview {
    AnimatedGIFView(name: "1")
        .frame(width: 250, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
}
