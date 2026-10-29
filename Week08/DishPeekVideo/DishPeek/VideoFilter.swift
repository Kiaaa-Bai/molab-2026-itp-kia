import CoreImage
import CoreImage.CIFilterBuiltins

nonisolated enum VideoEffect: String, CaseIterable {
    case mono = "Mono"
    case sepia = "Sepia"
    case comic = "Comic"
    case thermal = "Thermal"
    case bloom = "Bloom"
    case vignette = "Vignette"
    case pixellate = "Pixellate"
    case crystallize = "Crystallize"

    func apply(to image: CIImage, amount: Double) -> CIImage {
        let center = CGPoint(x: image.extent.midX, y: image.extent.midY)
        switch self {
        case .mono:
            let filter = CIFilter.colorControls()
            filter.inputImage = image
            filter.saturation = Float(1 - amount)
            return filter.outputImage ?? image
        case .sepia:
            let filter = CIFilter.sepiaTone()
            filter.inputImage = image
            filter.intensity = Float(amount)
            return filter.outputImage ?? image
        case .comic:
            let filter = CIFilter.comicEffect()
            filter.inputImage = image
            return mix(image, filter.outputImage, amount)
        case .thermal:
            let filter = CIFilter.falseColor()
            filter.inputImage = image
            filter.color0 = CIColor.red
            filter.color1 = CIColor.green
            return mix(image, filter.outputImage, amount)
        case .bloom:
            let filter = CIFilter.bloom()
            filter.inputImage = image.clampedToExtent()
            filter.intensity = Float(amount * 2)
            filter.radius = 40
            return filter.outputImage ?? image
        case .vignette:
            let filter = CIFilter.vignette()
            filter.inputImage = image
            filter.intensity = Float(amount * 3)
            filter.radius = 2
            return filter.outputImage ?? image
        case .pixellate:
            let filter = CIFilter.pixellate()
            filter.inputImage = image.clampedToExtent()
            filter.scale = Float(1 + amount * 59)
            filter.center = center
            return filter.outputImage ?? image
        case .crystallize:
            let filter = CIFilter.crystallize()
            filter.inputImage = image.clampedToExtent()
            filter.radius = Float(5 + amount * 75)
            filter.center = center
            return filter.outputImage ?? image
        }
    }
}

nonisolated struct FilterLayer: Identifiable, Equatable {
    let effect: VideoEffect
    var amount = 0.6
    var id: VideoEffect { effect }
}

nonisolated func mix(_ original: CIImage, _ filtered: CIImage?, _ amount: Double) -> CIImage {
    guard let filtered else { return original }
    let filter = CIFilter.dissolveTransition()
    filter.inputImage = original
    filter.targetImage = filtered
    filter.time = Float(amount)
    return filter.outputImage ?? original
}

nonisolated func applyFilters(_ image: CIImage, layers: [FilterLayer]) -> CIImage {
    var result = image
    for layer in layers {
        result = layer.effect.apply(to: result, amount: layer.amount)
        result = result.cropped(to: image.extent)
    }
    return result
}
