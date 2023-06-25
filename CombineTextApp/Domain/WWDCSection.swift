import Foundation

enum WWDCSection: CaseIterable {
  case Bring_widgets_to_life
  case Meet_SwiftData

  var viewData: ItemViewData {
    switch self {
    case .Bring_widgets_to_life:
      return .Bring_widgets_to_life
    case .Meet_SwiftData:
      return .Meet_SwiftData
    }
  }
}
