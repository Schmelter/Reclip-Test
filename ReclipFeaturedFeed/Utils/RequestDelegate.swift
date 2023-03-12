//
//  RequestDelegate.swift
//  ReclipFeaturedFeed
//

import Foundation

protocol RequestDelegate: AnyObject {
    func didUpdate(with state: ViewState)
}
