//
//  AppDelegate.swift
//  Fast Foodz
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator = AppCoordinator()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        startAppCoordinator()
        return true
    }
}

extension AppDelegate {
    private func configureWindow() {
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()

        // Set window's root vc with new navVC
        window?.rootViewController = appCoordinator.rootViewController
    }

    private func startAppCoordinator() {
        let initialIdx = UserDefaults.standard.selectedSegment
        appCoordinator.start(initialIdx)
    }
}
