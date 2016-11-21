/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit

import Parse
import OneSignal

// If you want to use any of the UI components, uncomment this line
// import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()

        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************

        PFUser.enableAutomaticUser()
        
        let config = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "bb977a915cfd57822eeefce36cc42f92a22f7488"
            ParseMutableClientConfiguration.clientKey = "964ac4f585e4bf832cd8b8dc06d943b4a5bb13e1"
            ParseMutableClientConfiguration.server = "http://ec2-35-163-220-244.us-west-2.compute.amazonaws.com:80/parse"
        }
        
        Parse.initialize(with: config)
        
        
        //push notification configuration
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "e67260a8-52df-47c6-9a40-0da681812fd7")

        let defaultACL = PFACL();

        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        defaultACL.getPublicWriteAccess = true

        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)

        if application.applicationState != UIApplicationState.background {
            
        }

        
        self.rememberLogin()
        
        return true
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        /*
        PFPush.handle(userInfo)
        if application.applicationState == UIApplicationState.inactive {
            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
    */
    }

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
    
    
    func rememberLogin() {
        
        let user : String? = UserDefaults.standard.string(forKey: "userinfo")
        
        if user != nil {
            
            print("not nil")
           
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let tabBar = board.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            
            window?.rootViewController = tabBar
        }
        
    }
    
    
}
