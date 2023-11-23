//
//  DownloadingClient.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/14/23.
//

import SwiftUI

public protocol DownloadingClient: Sendable {
    associatedtype RemoteContent
    
    func downloadContentFrom(remoteURL: URL) async throws -> RemoteContent
    
}
