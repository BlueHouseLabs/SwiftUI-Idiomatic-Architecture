//
//  URLSessionDownloadingClient.swift
//
//
//  Created by Eric DeLabar on 11/17/23.
//

import XCTest

@testable import BespokeTesting
@testable import ISArchitectureTestHelpers
@testable import ISArchitecture

final class URLSessionDownloadingClientTests: XCTestCase {

    func testDownloadContentFrom_Success() async throws {
        
        let expected = "Hello World"
        let fileURL = URL(string: "file:///temp.file")!
        
        let fakeURLSession = FakeDownloadTaskCreating.successDownloader(fileURL: fileURL)
        
        let cut = URLSessionDownloadingClient(
            builder: FakeBuilder<String>{ url in
                XCTAssertEqual(url, fileURL)
                return expected
            },
            urlSessionBuilder: {
                fakeURLSession
            }
        )
        
        let targetURL = URL(string: "https://www.google.com/")!
        
        let result = try await cut.downloadContentFrom(remoteURL: targetURL)
        
        XCTAssertEqual(result, expected)
        XCTAssertEqual(fakeURLSession.urls, [targetURL])
        
    }
    
    func testDownloadContentFrom_DownloadFailure() async throws {
        
        let fakeURLSession = FakeDownloadTaskCreating.failureDownloader(error: TestError())
        
        let cut = URLSessionDownloadingClient(
            builder: FakeBuilder<String>{ _ in
                XCTFail("Builder should not be run.")
                return ""
            },
            urlSessionBuilder: {
                fakeURLSession
            }
        )
        
        let targetURL = URL(string: "https://www.google.com/")!
        
        let result = try? await cut.downloadContentFrom(remoteURL: targetURL)
        
        XCTAssertNil(result)
        XCTAssertEqual(fakeURLSession.urls, [targetURL])
        
    }
    
    func testDownloadContentFrom_BuilderFailure() async throws {
        
        let fileURL = URL(string: "file:///temp.file")!
        
        let fakeURLSession = FakeDownloadTaskCreating.successDownloader(fileURL: fileURL)
        
        let cut = URLSessionDownloadingClient(
            builder: FakeBuilder<String>{ _ in
                return nil
            },
            urlSessionBuilder: {
                fakeURLSession
            }
        )
        
        let targetURL = URL(string: "https://www.google.com/")!
        
        let result = try? await cut.downloadContentFrom(remoteURL: targetURL)
        
        XCTAssertNil(result)
        XCTAssertEqual(fakeURLSession.urls, [targetURL])
        
    }

}
