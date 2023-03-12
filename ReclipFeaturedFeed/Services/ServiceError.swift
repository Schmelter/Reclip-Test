//
//  ServiceErrors.swift
//  ReclipFeaturedFeed
//

import Foundation

enum ServiceError {
    case noConnection, noData
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "No Data returned from API"
        case .noConnection: return "Cannot Connect to API"
        }
    }
}
