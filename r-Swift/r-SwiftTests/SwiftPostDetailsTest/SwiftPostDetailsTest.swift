//
//  SwiftPostDetailsTest.swift
//  r-SwiftTests
//
//  Created by Sachin Ambegave on 17/02/22.
//

@testable import r_Swift
import XCTest

// MARK: - SwiftPostDetailsTest

class SwiftPostDetailsTest: XCTestCase {
    var sut: PostDetailsViewController!
    var mockedViewModel: RSwiftPostsProtocol!
    var path: String!
    var stubbedData: Data!

    // MARK: setUpWithError

    override func setUpWithError() throws {
        sut = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
            .instantiateViewController(identifier: PostDetailsViewController.identifier) as? PostDetailsViewController
        path = Bundle.main.path(forResource: "rSwiftPosts", ofType: "json")!
        stubbedData = FileManager.default.contents(atPath: path)!
        mockedViewModel = RSwiftViewModel()
        mockedViewModel.handleResponse(from: stubbedData) { _ in }
        let validPost = mockedViewModel.posts.value?.first(where: { $0.title != "" })
        sut.post = validPost
        sut.viewDidAppear(false)
        
    }

    // MARK: testPostHasValidTitle

    func testPostHasValidTitle() {
        // given
        XCTAssertTrue(sut.post != nil)

        // when
        XCTAssertTrue(sut.post?.title != nil && sut.post?.title != "")
//        sut.title = sut.post?.title

        // then

        XCTAssertTrue(sut.title == sut.post?.title)
    }

    // MARK: tearDownWithError

    override func tearDownWithError() throws {
        sut = nil
        path = nil
        stubbedData = nil
        mockedViewModel = nil
        try super.tearDownWithError()
    }
}
