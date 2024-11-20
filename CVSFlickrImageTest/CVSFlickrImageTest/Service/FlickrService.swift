//
//  FlickrService.swift
//  CVSFlickrImageTest
//
//  Created by Joseph Nash on 11/19/24.
//

import UIKit
import Combine

protocol FlickrService: AnyObject {
  func getItemsBySearching(forTags tagList: String) -> AnyPublisher<[FlickrItem], Error>
  func fetchImage(forURL url: String) -> AnyPublisher<UIImage, Error>
}

class RealFlickrService: FlickrService {
  
  private static var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }()

  var imageCache: [String: UIImage] = [:]
  var inProgressImageFetches: [String: AnyPublisher<UIImage, Error>] = [:]
  let searchURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="

  func getItemsBySearching(forTags tagList: String) -> AnyPublisher<[FlickrItem], Error> {
    guard let encodedTags = tagList.addingPercentEncoding(withAllowedCharacters: .alphanumerics), let requestURL = URL(string: searchURL+encodedTags) else {
      return Fail(error: NSError(domain: "Bad URL", code: -1))
        .eraseToAnyPublisher()
    }
    let request = URLRequest(url: requestURL)
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { result in
        guard (result.response as? HTTPURLResponse)?.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        return result.data
      }
      .decode(type: FlickrImageResponse.self, decoder: Self.decoder)
      .map {
        $0.items
      }
      .eraseToAnyPublisher()
  }

  func fetchImage(forURL url: String) -> AnyPublisher<UIImage, Error> {
    if let image = imageCache[url] {
      // We already have an image for this URL. No need to fetch, give the image
      return Result.Publisher(image).eraseToAnyPublisher()
    }
    guard let requestURL = URL(string: url) else {
      return Fail(error: NSError(domain: "Bad URL", code: -1))
        .eraseToAnyPublisher()
    }
    // See if we are already in the middle of making the same request. Prevent duplicates
    // If not nil, return that publisher
    if let inProgressFetch = inProgressImageFetches[url] {
      return inProgressFetch
    }
    // No existing image or request, make new request
    let request = URLRequest(url: requestURL)
    let imageFetchPublisher = URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { [weak self] result -> UIImage in
        // remove in-progress fetch, we got the result back
        self?.inProgressImageFetches[url] = nil
        guard (result.response as? HTTPURLResponse)?.statusCode == 200,
              let image = UIImage(data: result.data) else {
          throw URLError(.badServerResponse)
        }
        // Add image to cache
        self?.imageCache[url] = image
        return image
      }
      .eraseToAnyPublisher()
    inProgressImageFetches[url] = imageFetchPublisher
    return imageFetchPublisher
  }
}
