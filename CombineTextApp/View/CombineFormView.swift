import SwiftUI
import CoreData

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else

#endif

struct CombineFormView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  @State var title: String = ""
  @State var linkURLText: String = ""
  @State var text1: String = ""
  @State var text2: String = ""
  @State var result: String = ""

  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        VStack(alignment: .leading) {
          Text("Title")
          TextField("WWDC23", text: $title)
        }

        VStack(alignment: .leading) {
          Text("Link")
          TextField("https://developer.apple.com/videos/play/wwdc2023/101/", text: $linkURLText)
        }

        VStack(alignment: .leading) {
          Text("English")
          TextEditor(text: $text1)
            .frame(height: 120)
        }

        VStack(alignment: .leading) {
          Text("Translate")
          TextEditor(text: $text2)
            .frame(height: 120)
        }

        if !result.isEmpty {
          VStack {
            Text("Combine")
            TextEditor(text: $result)
              .frame(height: 120)
          }
        }

        Button {
          result = CombineTextService.combineText(text1: text1, text2: text2)
          copyClipBoard(value: result)
        } label: {
          Text("Combine")
            .bold()
        }
        .buttonStyle(.borderedProminent)
        .disabled(text1.isEmpty && text2.isEmpty)

        Button {
          addItem(result: result)
          dismiss()
        } label: {
          Text("Save")
            .bold()
        }
        .buttonStyle(.borderedProminent)
        .disabled(result.isEmpty)
      }
      .frame(minWidth: 300, maxWidth: .infinity)
      .padding(32)
    }
  }

  private func copyClipBoard(value: String) {
#if canImport(UIKit)
    UIPasteboard.general.string = value
#elseif canImport(AppKit)
    NSPasteboard.general.setString(value, forType: .string)
#else
#endif
  }

  private func addItem(result: String) {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.id = UUID()
      newItem.timestamp = Date()
      newItem.title = title
      newItem.firstText = text1
      newItem.translateText = text2
      newItem.combineText = result

      if let linkURL = URL(string: linkURLText) {
        newItem.linkURL = linkURL
      }

      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

struct CombineFormView_Previews: PreviewProvider {
    static var previews: some View {
        CombineFormView()
    }
}
