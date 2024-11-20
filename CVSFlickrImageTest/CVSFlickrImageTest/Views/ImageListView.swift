//
//  ImageListView.swift
//  CVSFlickrImageTest
//
//  Created by Joseph Nash on 11/19/24.
//

import SwiftUI
import Combine

class ImageListViewModel: ObservableObject {
  @Published var tags: String = ""
  @Published var items: [FlickrItem] = []
  @Published var error: Error? = nil
  @Published var isShowingError = false
  @Published var isLoading = true

  var service: FlickrService = RealFlickrService()
  var fetchSubscription: AnyCancellable?

  func fetchItems() {
    isLoading = true
    fetchSubscription = service.getItemsBySearching(forTags: tags)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] result in
        switch result {
          case .failure(let error):
            self?.error = error
            self?.isShowingError = true
          case .finished:
            break
        }
        self?.isLoading = false
      }, receiveValue: { [weak self] items in
        self?.items = items
      })
  }

}

struct ImageListView: View {
  @ObservedObject var viewModel = ImageListViewModel()

  var body: some View {
    NavigationView {
      VStack {
        TextField("Image Tags (comma-separated)", text: $viewModel.tags)
          .onChange(of: viewModel.tags){ _ in
          viewModel.fetchItems()
        }
          .textFieldStyle(.roundedBorder)
          .padding()
        ScrollView(.vertical) {
          LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), alignment: .bottom)], spacing: 12) {
            ForEach(viewModel.items) { item in
              NavigationLink {
                ImageDetailView(item: item)
                  .navigationTitle(item.title)
              } label: {
                ImageThumbnailView(media: item.media)
              }
              .padding()
            }
          }
          .padding()
          .modifier(LoadingViewOverlay(isShowing: $viewModel.isLoading))
          .alert(viewModel.error.debugDescription, isPresented: $viewModel.isShowingError) {
            Button("Retry", role: .cancel) {
              viewModel.isShowingError = false
              viewModel.error = nil
              viewModel.fetchItems()
            }
          }
        }
        .navigationBarTitle("Images", displayMode: .inline)
      }
      .task {
        viewModel.fetchItems()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ImageListView()
  }
}
