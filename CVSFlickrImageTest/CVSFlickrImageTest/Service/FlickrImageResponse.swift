//
//  FlickrImageResponse.swift
//  CVSFlickrImageTest
//
//  Created by Joseph Nash on 11/19/24.
//

import Foundation

struct FlickrImageResponse: Codable {
  let items: [FlickrItem]
}

struct FlickrItem: Codable, Identifiable {
  let id: String
  let title: String
  let media: FlickrMedia
  let description: String
  let dateTaken: Date
  let author: String
  let tags: String
  private enum CodingKeys: String, CodingKey {
    case title, media, description, author, tags
    case dateTaken = "date_taken"
    // Link is unique, so using it in place of a proper id
    case id = "link"
  }
}

struct FlickrMedia: Codable {
  let imageURL: String
  private enum CodingKeys: String, CodingKey {
    case imageURL = "m"
  }
}
