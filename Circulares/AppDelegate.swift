//
//  AppDelegate.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//

import UIKit
import FirebaseCore
import Foundation
import GoogleSignIn
import UserNotifications
import Firebase
import FirebaseCore
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
          
      }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       
        
        
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { (token, error) in
            if let error = error {
                NotificationCenter.default.post(name: Notification.Name("CHMD"), object: error)
            } else if let token = token {
                NotificationCenter.default.post(name: Notification.Name("CHMD"), object: token)
                print("token generado: \(token)")
                
                let os = ProcessInfo().operatingSystemVersion
                let so = "iOS \(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
                
                UserDefaults.standard.set(token, forKey: "deviceToken")
                
               
                
            }
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
    
    
    
    
      func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
                       [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
          
          GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
              if error != nil || user == nil {
                // Show the app's signed-out state.
              } else {
                // Show the app's signed-in state.
              }
            }
          
        registerForPushNotifications()
        return true
      }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    
   

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    
}


