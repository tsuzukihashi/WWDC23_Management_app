import SwiftUI
import CoreData

struct ContentView: View {
  @State var showPostView: Bool = false
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default
  )
  private var items: FetchedResults<Item>

  var body: some View {
    NavigationView {
      List {
        ForEach(items.compactMap { $0.convert() }) { viewData in
          NavigationLink {
            ItemDetailView(viewData: viewData)
          } label: {
            Text(viewData.title)
          }
        }
        .onDelete(perform: deleteItems)

        NavigationLink {
          ScrollView {
            VStack(alignment: .leading) {
              ForEach(WWDCSection.allCases, id: \.self) { section in
                NavigationStack {
                  NavigationLink {
                    ItemDetailView(viewData: section.viewData)
                  } label: {
                    Text(section.viewData.title)
                  }
                }
              }
            }
          }
        } label: {
          Text("WWDCSection")
        }

      }
      .sheet(isPresented: $showPostView, content: {
        CombineFormView()
      })
      .toolbar {
#if os(iOS)
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
#endif
        ToolbarItem {
          Button(action: toggleSheet) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      Text("Select an item")
    }
  }

  private func toggleSheet() {
    showPostView.toggle()
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
