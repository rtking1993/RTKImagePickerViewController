// MARK: Filter

struct Filter {
    let title: String
    let filterType: FilterType
}

// MARK: FilterType

enum FilterType: String {
    case original = "original"
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case instant = "CIPhotoEffectInstant"
    case noir = "CIPhotoEffectNoir"
    case process = "CIPhotoEffectProcess"
    case tonal = "CIPhotoEffectTonal"
    case transfer = "CIPhotoEffectTransfer"
    case sepia = "CISepiaTone"
}

let filters: [Filter] = [Filter(title: "Original", filterType: .original),
                        Filter(title: "Chrome", filterType: .chrome),
                        Filter(title: "Fade", filterType: .fade),
                        Filter(title: "Instant", filterType: .instant),
                        Filter(title: "Noir", filterType: .noir),
                        Filter(title: "Process", filterType: .process),
                        Filter(title: "Tonal", filterType: .tonal),
                        Filter(title: "Transfer", filterType: .transfer),
                        Filter(title: "Sepia", filterType: .sepia)]
