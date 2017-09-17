//
//  AppDelegate.swift
//  MovieReviews
//
//  Created by drishi on 9/13/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyBoard = UIStoryboard(name:"Main", bundle:nil)
        
        // Root navigation controller for 'now playing'
        let nowPlayingRootNavigationController = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingRootNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.tabBarItem.title = "Now Playing"
        nowPlayingViewController.endpoint = "now_playing"
        nowPlayingViewController.tabBarItem.image = UIImage(named: "film-clap-board")

        // Root navigation controller for 'top rated'
        let topRatedNavigationController = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.tabBarItem.title = "Top Rated"
        topRatedViewController.endpoint = "top_rated"
        topRatedViewController.tabBarItem.image = UIImage(named: "star")
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingRootNavigationController, topRatedNavigationController]
        tabBarController.tabBar.tintColor = UIColor.red
        tabBarController.tabBar.barTintColor = UIColor.black
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

