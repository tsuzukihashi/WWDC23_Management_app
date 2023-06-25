import SwiftUI

struct ItemDetailView: View {
  @State var redraw: Bool = false
  var viewData: ItemViewData

  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .leading) {
          if let linkURL = viewData.linkURL {
            Link(destination: linkURL) {
              Text(linkURL.absoluteString)
            }
          }

          Text(viewData.combineText)
            .textSelection(.enabled)
        }
      }
    }
    .toolbar {
      ToolbarItem {
        Button {
          copyInitializer()
        } label: {
          Text("Copy Initializer")
        }
      }
    }

  }

  private func copyInitializer() {
    let enumTitle = viewData.title.replacingOccurrences(of: " ", with: "_")
    let linkURL = viewData.linkURL?.absoluteString ?? "nil"
    let result: String = """
    import Foundation
    
    extension ItemViewData {
      static var \(enumTitle): ItemViewData {
        .init(
          id: UUID().uuidString,
          title: "\(viewData.title)",
          linkURL: URL(string: \"\(linkURL)\"),
          firstText:\"\"\"\n\(viewData.firstText)\n\"\"\",
          translateText: \"\"\"\n\(viewData.translateText)\n\"\"\",
          combineText: \"\"\"\n\(viewData.combineText)\n\"\"\",
          timestamp: Date()
        )
      }
    }
    """

    copyClipBoard(value: result)
  }

  private func copyClipBoard(value: String) {
#if canImport(UIKit)
    UIPasteboard.general.string = value
#elseif canImport(AppKit)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(value, forType: .string)
#else
#endif
  }
}

