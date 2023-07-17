import UIKit
import RealmSwift
import UserNotifications
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var homeScreenViewControllerReference: UIViewController?
        
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Realm database path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        

        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    print("Attempting to register for remote notifications")
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        return true
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Could not register for APNS notifications \(error)")
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func returnToHomeScreen() {
        if let homeScreenViewController = homeScreenViewControllerReference {
            homeScreenViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}


extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
                        
        let notificationPayload = notification.request.content.userInfo
        let contentToLaunch : String = notificationPayload["contentToLaunch"] as? String ?? "undefined"
        let itemToLaunch : String = notificationPayload["itemToLaunch"] as? String ?? "undefined"
        let contentBody : String = notification.request.content.body
        print("AppDelegate - willPresent - content to launch: \(contentToLaunch) and item to launch: \(itemToLaunch)")
        
        let notificationManager = NotificationManager()
        notificationManager.processNotificationReceivedWhilstInForeground(contentToLaunch: contentToLaunch, itemToLaunch: itemToLaunch, contentBody: contentBody)

        completionHandler([])
    }
    

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let notificationPayload = response.notification.request.content.userInfo
        let contentToLaunch : String = notificationPayload["contentToLaunch"] as? String ?? "undefined"
        let itemToLaunch : String = notificationPayload["itemToLaunch"] as? String ?? "undefined"

        let notificationManager = NotificationManager()
        print("Trigger notification handler")
        notificationManager.processClickedUponNotificationFromExternalNotification(contentToLaunch: contentToLaunch, itemToLaunch: itemToLaunch)
        
        completionHandler()
    }
}


extension UIApplication {    
    static var topMostViewController: UIViewController? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.visibleViewController
    }
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
    }

}

extension UIViewController {
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
}
