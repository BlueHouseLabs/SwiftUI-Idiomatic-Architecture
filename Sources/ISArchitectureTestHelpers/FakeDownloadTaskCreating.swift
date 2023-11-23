//
//  FakeDownloadTaskCreating.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation
@testable import ISArchitecture

class FakeDownloadTaskCreating: DownloadTaskCreating {
    
    class FakeDownloadTask: DownloadTask {
        
        let result: Result<URL, Error>
        let response: URLResponse?
        let completionHandler: @Sendable (Result<URL, Error>, URLResponse?) -> Void
        
        init(
            result: Result<URL, Error>,
            response: URLResponse?,
            completionHandler: @escaping @Sendable (Result<URL, Error>, URLResponse?) -> Void
        ) {
            self.result = result
            self.response = response
            self.completionHandler = completionHandler
        }
        
        func resume() {
            completionHandler(result, response)
        }
    }
    
    var urls: [URL] = []
    
    let result: Result<URL, Error>
    let response: URLResponse?
    
    required init(result: Result<URL, Error>, response: URLResponse?) {
        self.result = result
        self.response = response
    }
    
    static func successDownloader(fileURL: URL, response: URLResponse = URLResponse()) -> Self {
        Self(
            result: .success(fileURL),
            response: response
        )
    }
    
    static func failureDownloader(error: Error, response: URLResponse = URLResponse()) -> Self {
        Self(
            result: .failure(error),
            response: response
        )
    }
    
    func downloadTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Result<URL, Error>, URLResponse?) -> Void
    ) -> DownloadTask {
        urls.append(url)
        return FakeDownloadTask(
            result: result,
            response: response,
            completionHandler: completionHandler
        )
    }
}
