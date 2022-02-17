//
//  SwiftPostDetailsCellTests.swift
//  r-SwiftTests
//
//  Created by Sachin Ambegave on 17/02/22.
//

@testable import r_Swift
import XCTest

// MARK: - SwiftPostDetailsCellTests

class SwiftPostDetailsCellTests: XCTestCase {
    var sut: PostDetailTableViewCell!
    var viewController: PostDetailsViewController!
    var mockedViewModel: RSwiftPostsProtocol!
    var path: String!
    var stubbedData: Data!

    // MARK: setUpWithError

    override func setUpWithError() throws {
        viewController = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
            .instantiateViewController(identifier: PostDetailsViewController.identifier) as? PostDetailsViewController
        path = Bundle.main.path(forResource: "rSwiftPosts", ofType: "json")!
        stubbedData = FileManager.default.contents(atPath: path)!
        mockedViewModel = RSwiftViewModel()
        mockedViewModel.handleResponse(from: stubbedData) { _ in }
    }

    // MARK: testIsNotAValidCell

    func testIsNotAValidCell() {
        XCTAssertTrue(sut == nil)
    }

    // MARK: testIsValidCell

    func testIsValidCell() {
        // given
        let post = mockedViewModel.posts.value?.first(where: { $0.title != "" })

        // when
        XCTAssertTrue(post != nil)

        // then
        viewController.post = post
        viewController.tableView.reloadData()
        sut = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PostDetailTableViewCell

        XCTAssertTrue(sut != nil)
    }

    // MARK: testPostCellContainsValidTitle

    func testPostCellContainsValidTitle() {
        // given
        let post = mockedViewModel.posts.value?.first(where: { $0.title != "" })

        // when
        XCTAssertTrue(post != nil)

        // then
        viewController.post = post
        viewController.tableView.reloadData()
        sut = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PostDetailTableViewCell
        sut?.configure(post!)

        XCTAssertTrue(sut.postDescriptionLabel.text == post?.description)
    }

    // MARK: tearDownWithError

    override func tearDownWithError() throws {
        sut = nil
        path = nil
        stubbedData = nil
        mockedViewModel = nil
        viewController = nil
        try super.tearDownWithError()
    }
}
