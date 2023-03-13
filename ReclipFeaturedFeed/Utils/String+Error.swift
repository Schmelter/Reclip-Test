//
//  String+Error.swift
//  ReclipFeaturedFeed
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
