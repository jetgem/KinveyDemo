//
//  AppDelegate.swift
//  kinveytest
//
//  Created by jetgem on 1/14/19.
//  Copyright © 2019 jetgem. All rights reserved.
//

import UIKit
import Kinvey

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Kinvey.sharedClient.initialize(
            appKey: "kid_HJIrBbcGV",
            appSecret: "37fdad7730f7460bbf8fd77c62d0df4e"
        ) {
            switch $0 {
            case .success(let user):
                if user == nil {
                    User.login(username: "kinveytest", password: "kinveytest", options: nil) { (result: Result<User, Swift.Error>) in
                        switch result {
                        case .success(let user):
                            //the log-in was successful and the user is now the active user and credentials saved
                            //hide log-in view and show main app content
                            print("User: \(user)")
                            
                            self.makeQuery()
                        case .failure(let error):
                            //there was an error with the update save
                            let message = error.localizedDescription
                            print(message)
                        }
                    }
                } else {
                    self.makeQuery()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
        
        Kinvey.sharedClient.ping() { (result: Result<EnvironmentInfo, Swift.Error>) in
            switch result {
            case .success(let envInfo):
                print(envInfo)
            case .failure(let error):
                print(error)
            }
        }
        
        let completionHandler = { (result: Result<Bool, Swift.Error>) in
            switch result {
            case .success(let succeed):
                print("succeed: \(succeed)")
            case .failure(let error):
                print("error: \(error)")
            }
        }
        if #available(iOS 10.0, *) {
            Kinvey.sharedClient.push.registerForNotifications(options: nil, completionHandler: completionHandler)
        } else {
            Kinvey.sharedClient.push.registerForPush(completionHandler: completionHandler)
        }

        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Push Notification handling code should be performed here
    }
    
    func makeQuery() {
        do {
            let dataStore = try DataStore<Target>.collection(.network)
            
            let query = Query(format: "appId == %@", Bundle.main.bundleIdentifier!)
            dataStore.find(query) { (result: Result<AnyRandomAccessCollection<Target>, Swift.Error>) in
                switch result {
                case .success(let targets):
                    if targets.count > 0 {
                        let isEnabled = targets[0].isEnabled
                        print("Enabled: ", isEnabled)
                        if isEnabled {
                            
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        } catch {
            
        }
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

