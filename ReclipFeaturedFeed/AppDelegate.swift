//
//  AppDelegate.swift
//  ReclipFeaturedFeed
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.overrideUserInterfaceStyle = .light
        newWindow.makeKeyAndVisible()
        newWindow.rootViewController = RootViewController()
        window = newWindow
        return true
    }
}
