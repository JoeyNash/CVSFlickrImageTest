//
//  ImageThumbnailView.swift
//  CVSFlickrImageTest
//
//  Created by Joseph Nash on 11/19/24.
//

import SwiftUI

struct ImageThumbnailView: View {
  let media: FlickrMedia

  var body: some View {
    VStack {
      AsyncImage(url: URL(string: media.imageURL)) { image in
        image
          .resizable()
          .scaledToFit()
      } placeholder: {
        ProgressView()
          .progressViewStyle(.circular)
      }
      .frame(width: 100, height: 100)
    }
  }
}

struct ImageThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
      ImageThumbnailView(media: FlickrMedia(imageURL: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg"))
    }
}
