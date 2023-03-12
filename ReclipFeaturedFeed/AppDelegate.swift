//
//  AppDelegate.swift
//  ReclipFeaturedFeed
//

import UIKit
import AVFoundation

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.overrideUserInterfaceStyle = .light
        newWindow.makeKeyAndVisible()
        newWindow.rootViewController = RootViewController()
        window = newWindow
        return true
    }
}
