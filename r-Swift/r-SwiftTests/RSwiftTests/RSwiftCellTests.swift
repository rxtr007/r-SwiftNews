//
//  RSwiftCellTests.swift
//  r-SwiftTests
//
//  Created by Sachin Ambegave on 17/02/22.
//

@testable import r_Swift
import XCTest

// MARK: - RSwiftCellTests

class RSwiftCellTests: XCTestCase {
    var sut: PostTableViewCell!
    var viewController: RSwiftRedditViewController!
    var mockedViewModel: RSwiftPostsProtocol!
    var path: String!
    var stubbedData: Data!

    // MARK: setUpWithError

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
            .instantiateViewController(identifier: RSwiftRedditViewController.identifier) as? RSwiftRedditViewController
        mockedViewModel = RSwiftViewModel()
        viewController.viewModel = mockedViewModel
        path = Bundle.main.path(forResource: "rSwiftPosts", ofType: "json")!
        stubbedData = FileManager.default.contents(atPath: path)!
        viewController.viewModel.handleResponse(from: stubbedData) { _ in }
    }

    // MARK: tearDownWithError

    override func tearDownWithError() throws {
        path = nil
        stubbedData = nil
        mockedViewModel = nil
        sut = nil
        viewController = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: testIsNotAValidCell

    func testIsNotAValidCell() {
        XCTAssertTrue(sut == nil)
    }

    // MARK: testIsValidCell

    func testIsValidCell() {
        // given
        let posts = viewController.viewModel.posts.value!.count

        // when
        XCTAssertTrue(posts != 0)

        // then
        viewController.tableView.reloadData()
        sut = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PostTableViewCell

        XCTAssertTrue(sut != nil)
    }

    // MARK: testPostCellContainsValidTitle

    func testPostCellContainsValidTitle() {
        // given
        let posts = viewController.viewModel.posts.value!

        // when
        XCTAssertTrue(posts.count != 0)

        // then
        viewController.tableView.reloadData()
        sut = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PostTableViewCell
        sut?.configure(posts.first!)

        XCTAssertTrue(sut.postTitleLabel.text != "")
    }
}
