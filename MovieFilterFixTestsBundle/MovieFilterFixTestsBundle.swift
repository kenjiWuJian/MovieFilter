//
//  MovieFilterFixTestsBundle.swift
//  MovieFilterFixTestsBundle
//
//  Created by JoannaWQ on 29/3/20.
//  Copyright © 2020 Wu Jian. All rights reserved.
//

import XCTest
@testable import MovieFilterFix
class MovieFilterFixTestsBundle: XCTestCase {
    
    var systemUnderTest:ViewController!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        systemUnderTest = ViewController()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
         systemUnderTest = nil
        super.tearDown()
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
   //no idea if this kind of remote request can test this way or not
    func testSearchResult(){
        systemUnderTest.result1.removeAll()
        systemUnderTest.loadAPIkey()
        systemUnderTest.movieManager.getAppId(appId: ViewController.apikey)
        let movieURL = systemUnderTest.movieManager.fetchMovie(userInput: "with_original_language=hi", page: 1)
        
        systemUnderTest.movieManager.performRequest(urlString: movieURL)
        
        let exp = expectation(description: "Test after 3 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 3.0)
        if result == XCTWaiter.Result.timedOut {
           // XCTAssert(<test if state is correct after this delay>)
            XCTAssertGreaterThan(systemUnderTest.result1.count, 0, "passed, vote average\(systemUnderTest.result1.count)")
            //XCTAssertNotNil(systemUnderTest.result1[0].vote_average, "test passed, get \(systemUnderTest.result1[0].vote_average) results")
        } else {
            XCTFail("Delay interrupted")
        }
        
    }
    
    
    //This test can modify api key stored in UserDefault

     func testSaveLoadApiKey(){
     //1. Given
     //ViewController.apikey = ""
     //2. When
     systemUnderTest.saveAPIkey(key: "testApiKey")
     systemUnderTest.loadAPIkey()
     //3. Then
     XCTAssertEqual( ViewController.apikey ,"testApiKey", "input output api key equal, pass")
     }
  
    
}
