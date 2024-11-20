//
//  CVSFlickrImageTestTests.swift
//  CVSFlickrImageTestTests
//
//  Created by Joseph Nash on 11/19/24.
//

import XCTest
import Combine
@testable import CVSFlickrImageTest

class CVSFlickrImageTestTests: XCTestCase {
  
  var subscription: AnyCancellable?

  override func setUp() async throws {
    subscription = nil
  }

  func testViewModel_Success() {
    let expectation = XCTestExpectation(description: "Got items")
    let viewModel = ImageListViewModel()
    let mockService = MockFlickrService()
    viewModel.service = mockService
    viewModel.fetchItems()
    XCTAssert(viewModel.isLoading)
    XCTAssertFalse(viewModel.isShowingError)
    subscription = viewModel.$items
      .sink(receiveValue: { items in
        if !items.isEmpty {
          expectation.fulfill()
        }
      })
    wait(for: [expectation], timeout: 10)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isShowingError)
    XCTAssertEqual(viewModel.items.count, 2)
  }

  func testViewModel_Failure() {
    let expectation = XCTestExpectation(description: "Got error")
    let viewModel = ImageListViewModel()
    let mockService = MockFlickrService()
    mockService.shouldReturnError = true
    viewModel.service = mockService
    viewModel.fetchItems()
    XCTAssert(viewModel.isLoading)
    XCTAssertFalse(viewModel.isShowingError)
    subscription = viewModel.$error
      .sink(receiveValue: { error in
        if error != nil {
          expectation.fulfill()
        }
      })
    wait(for: [expectation], timeout: 10)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssert(viewModel.isShowingError)
  }

}

fileprivate class MockFlickrService: FlickrService {
  var shouldReturnError = false
  func getItemsBySearching(forTags tagList: String) -> AnyPublisher<[FlickrItem], Error> {
    if shouldReturnError {
      return Fail(error: NSError(domain: "Test", code: -1))
        .eraseToAnyPublisher()
    }
    let item1 = FlickrItem(id: "1", title: "Item1", media: .init(imageURL: ""), description: "Description1", dateTaken: Date(), author: "Author1", tags: "tag, 1")
    let item2 = FlickrItem(id: "2", title: "Item2", media: .init(imageURL: ""), description: "Description2", dateTaken: Date(), author: "Author2", tags: "tag, 2")
    return Just([item1, item2])
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  func fetchImage(forURL url: String) -> AnyPublisher<UIImage, Error> {
    // Just protocol conformance for now
    Just(UIImage())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
