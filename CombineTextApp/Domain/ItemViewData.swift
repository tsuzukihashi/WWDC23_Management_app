import Foundation

struct ItemViewData: Identifiable {
  var id: String
  var title: String
  var linkURL: URL?
  var firstText: String
  var translateText: String
  var combineText: String
  var timestamp: Date
}
