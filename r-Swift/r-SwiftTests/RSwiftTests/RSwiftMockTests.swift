//
//  RSwiftMockTests.swift
//  r-SwiftTests
//
//  Created by Sachin Ambegave on 17/02/22.
//

@testable import r_Swift
import XCTest

// MARK: - RSwiftMockTests

class RSwiftMockTests: XCTestCase {
    var sut: RSwiftRedditViewController!
    var mockedViewModel: RSwiftPostsProtocol!
    var path: String!
    var stubbedData: Data!

    // MARK: setUpWithError

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
            .instantiateViewController(identifier: RSwiftRedditViewController.identifier) as? RSwiftRedditViewController
        mockedViewModel = RSwiftViewModel()
        sut.viewModel = mockedViewModel
        path = Bundle.main.path(forResource: "rSwiftPosts", ofType: "json")!
        stubbedData = FileManager.default.contents(atPath: path)!
        let promise = expectation(description: "Completion handler invoked")

        // when
        sut.viewModel.handleResponse(from: stubbedData) { _ in

            // then
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    // MARK: tearDownWithError

    override func tearDownWithError() throws {
        sut = nil
        mockedViewModel = nil
        path = nil
        stubbedData = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: tearDownWithError

    func testPostFromRSwiftLoads() {
        // given
        let posts = sut.viewModel.posts.value!.count

        // when
        XCTAssertTrue(posts != 0)

        // then
        XCTAssertTrue(sut.tableView.numberOfRows(inSection: 0) != 0)
    }
}
