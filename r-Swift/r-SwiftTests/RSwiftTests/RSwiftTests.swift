//
//  r_SwiftTests.swift
//  r-SwiftTests
//
//  Created by Sachin Ambegave on 17/02/22.
//

@testable import r_Swift
import XCTest

// MARK: - r_SwiftTests

class r_SwiftTests: XCTestCase {
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

        sut.viewModel.handleResponse(from: stubbedData) { _ in }
    }

    // MARK: tearDownWithError

    override func tearDownWithError() throws {
        sut = nil
        mockedViewModel = nil
        path = nil
        stubbedData = nil
        try super.tearDownWithError()
    }

    // MARK: testPostsFromRSwiftNotEmpty

    func testPostsFromRSwiftNotEmpty() {
        // given
        let posts = sut.viewModel.posts.value!.count

        // when
        XCTAssertTrue(posts != 0)

        // then
        XCTAssertTrue(sut.tableView.numberOfRows(inSection: 0) != 0)
    }
}
