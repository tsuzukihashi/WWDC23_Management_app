import Foundation

extension Item {
  func convert() -> ItemViewData? {
    guard let id,
          let title,
          let firstText,
          let translateText,
          let combineText,
          let timestamp else { return nil }

    return .init(
      id: id.uuidString,
      title: title,
      linkURL: linkURL,
      firstText: firstText,
      translateText: translateText,
      combineText: combineText,
      timestamp: timestamp
    )
  }
}
