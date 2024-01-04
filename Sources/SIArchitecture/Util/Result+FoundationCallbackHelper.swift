//
//  Result+FoundationCallbackHelper.swift
//
//
//  Created by Eric DeLabar on 11/17/23.
//

import Foundation

extension Result {
    /// Initializer for taking the optional Foundation completion parameters
    public init(success: Success?, failure: Failure?) {
        if let success {
            self = .success(success)
            return
        }
        // This whole thing relies on Foundation classes behaving as documented, so if they're not, the `!`
        // will cause a crash. (Not much else we can do without being able to construct a Failure...)
        self = .failure(failure!)
    }
}
