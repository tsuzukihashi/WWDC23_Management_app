import Foundation

enum WWDCSection: CaseIterable {
  case Bring_widgets_to_life
  case Meet_SwiftData
  case Model_your_schema_with_SwiftData
  case Build_an_app_with_SwiftData
  case Dive_deeper_into_SwiftData

  var viewData: ItemViewData {
    switch self {
    case .Bring_widgets_to_life:
      return .Bring_widgets_to_life
    case .Meet_SwiftData:
      return .Meet_SwiftData
    case .Model_your_schema_with_SwiftData:
      return .Model_your_schema_with_SwiftData
    case .Build_an_app_with_SwiftData:
      return .Build_an_app_with_SwiftData
    case .Dive_deeper_into_SwiftData:
      return .Dive_deeper_into_SwiftData
    }
  }
}
