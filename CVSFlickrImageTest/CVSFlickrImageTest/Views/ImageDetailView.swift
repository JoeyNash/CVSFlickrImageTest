//
//  ImageDetailView.swift
//  CVSFlickrImageTest
//
//  Created by Joseph Nash on 11/19/24.
//

import SwiftUI
import Foundation

struct ImageDetailView: View {
  let item: FlickrItem
  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 12) {
        AsyncImage(url: URL(string: item.media.imageURL)) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
            .progressViewStyle(.circular)
        }
        .frame(width: 200, height: 200)
        .padding()
        VStack(alignment: .leading) {
          HStack(alignment: .top) {
            Text("Title:")
              .fontWeight(.bold)
              .padding()
            Text(item.title)
              .padding()
          }
          HStack(alignment: .top) {
            Text("Description:")
              .fontWeight(.bold)
              .padding()
            Text(item.description)
              .padding()
          }
          HStack(alignment: .top) {
            Text("Author:")
              .fontWeight(.bold)
              .padding()
            Text(item.author)
              .padding()
          }
          HStack(alignment: .top) {
            Text("Date Uploaded:")
              .fontWeight(.bold)
              .padding()
            Text(DateFormatter.displayFormatter.string(from: item.dateTaken))
              .padding()
          }
        }
      }
    }
  }
}

struct ImageDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ImageDetailView(
      item:
        FlickrItem(
          id: "https://www.flickr.com/photos/schenfeld/54146489112/",
          title: "North American Porcupine",
          media: FlickrMedia(imageURL: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg"),
          description: "It's a porcupine. Not to be confused with a blue hedgehog.",
          dateTaken: Date(),
          author: "nobody@flickr.com (\"David Schenfeld\")",
          tags: "acadia maine porcupine barharbor unitedstates cadillacmountain mammal")
    )
  }
}
