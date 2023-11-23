//
//  URLSessionImageClient.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/14/23.
//

import SwiftUI

public protocol DownloadTaskCreating {
    func downloadTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Result<URL, Error>, URLResponse?) -> Void
    ) -> DownloadTask
}
extension URLSession: DownloadTaskCreating {
    public func downloadTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Result<URL, Error>, URLResponse?) -> Void
    ) -> DownloadTask {
        downloadTask(with: url, completionHandler: { url, response, error in
            completionHandler(.init(success: url, failure: error), response)
        })
    }
}

public protocol DownloadTask {
    func resume()
}
extension URLSessionDownloadTask: DownloadTask {}

public actor URLSessionDownloadingClient<Session: DownloadTaskCreating, Builder: Building>: DownloadingClient {
    
    private let builder: Builder
    
    private var urlSession: Session {
        urlSessionBuilder()
    }
    private let urlSessionBuilder: () -> Session
    
    public init(builder: Builder, urlSessionBuilder: @escaping () -> Session) {
        self.builder = builder
        self.urlSessionBuilder = urlSessionBuilder
    }
    
    public func downloadContentFrom(remoteURL: URL) async throws -> Builder.Built {
        try await withCheckedThrowingContinuation { [builder] continuation in
            
            let task = urlSession.downloadTask(with: remoteURL) { (result, _) in
                switch result {
                case .success(let downloadedFileURL):
                    do {
                        // per the docs, `downloadedFileURL` must be handled within the scope of this completion
                        // or it can be deleted.
                        let built = try builder.buildFrom(url: downloadedFileURL)
                        continuation.resume(returning: built)
                    } catch {
                        NSLog("Error converting downloaded data to instance of \(Builder.Built.self): \(error)")
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }

            task.resume()
        }
    }
    
}
