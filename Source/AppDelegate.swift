//
//  AppDelegate.swift
//  iOS-Snippets
//
//  Created by Anton Doudarev on 12/10/16.
//  Copyright © 2016 Anton Doudarev. All rights reserved.
//

import UIKit

class ViewController: UIViewController { }


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    // Template code you kick start your UI without 
    // all the intertface builder bullshit
    
    var window: UIWindow?
    var baseViewController: ViewController = ViewController()
    var baseNavViewController: UINavigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.baseNavViewController.view.backgroundColor = UIColor.white
        baseNavViewController.setNavigationBarHidden(true, animated: false)
        window = UIWindow(frame: UIScreen.main.bounds)
        baseNavViewController.pushViewController(baseViewController, animated: false)
        window?.rootViewController = self.baseNavViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
