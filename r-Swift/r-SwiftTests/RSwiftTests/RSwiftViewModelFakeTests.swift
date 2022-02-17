//
//  RSwiftViewModelTests.swift
//  r-SwiftTests
//
//  Created by Sachin Ambegave on 17/02/22.
//

@testable import r_Swift
import XCTest

// MARK: - RSwiftViewModelFakeTests

class RSwiftViewModelFakeTests: XCTestCase {
    var sut: RSwiftPostsProtocol!
    var path: String!
    var stubbedData: Data!
    var placeholderImage: UIImage!

    // MARK: setUpWithError

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RSwiftViewModel()
        path = Bundle.main.path(forResource: "rSwiftPosts", ofType: "json")!
        stubbedData = FileManager.default.contents(atPath: path)!
        placeholderImage = ImageLoader.placeholderSFImage
    }

    // MARK: tearDownWithError

    override func tearDownWithError() throws {
        sut = nil
        path = nil
        stubbedData = nil
        placeholderImage = nil
        try super.tearDownWithError()
    }

    // MARK: testPostsIsEmpty

    func testPostsIsEmpty() {
        // given
        let invalidData = "[1]".data(using: .utf8)!

        let promise = expectation(description: "Completion handler invoked")

        // when
        sut.handleResponse(from: invalidData) { _ in

            // then
            XCTAssertTrue(self.sut.posts.value!.isEmpty)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    // MARK: testPostsSerializedAndSavedCorrectly

    func testPostsSerializedAndSavedCorrectly() {
        // given stubbedData

        let promise = expectation(description: "Completion handler invoked")

        // when
        sut.handleResponse(from: stubbedData) { _ in

            // then
            XCTAssertTrue(!self.sut.posts.value!.isEmpty)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        XCTAssertTrue(sut.posts.value?.count != 0)
    }

    // MARK: testCellModelHasValidPlaceholderImage

    func testCellModelHasValidPlaceholderImage() {
        // given stubbedData

        let promise = expectation(description: "Completion handler invoked")

        // when
        sut.handleResponse(from: stubbedData) { _ in

            // then
            XCTAssertTrue(self.sut.posts.value?.count != 0)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        let modelsWithPlaceholder = sut.posts.value!.filter { $0.thumbnailImage == self.placeholderImage }.count
        let allModels = sut.posts.value!.count
        XCTAssertTrue(modelsWithPlaceholder == allModels)
    }
}
