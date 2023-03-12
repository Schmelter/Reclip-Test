//
//  ViewState.swift
//  ReclipFeaturedFeed
//

import Foundation


enum ViewState {
    case idle
    case loading
    case success
    case error(Error)
}
