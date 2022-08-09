import Foundation
import UIKit

class NotificationManager {
    
    func scheduleLocalNotification(notificationType: String, notificationTitle: String, notificationSubtitle: String, notificationDelay: Int, contentToLaunch: String, itemToLaunch: String, notificationUuid: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationSubtitle
        content.categoryIdentifier = "alarm"
        content.userInfo = ["contentToLaunch": contentToLaunch, "itemToLaunch": itemToLaunch]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(notificationDelay), repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationUuid, content: content, trigger: trigger)
        print("Setting up delayed system notification for title \(notificationTitle) - \(notificationSubtitle) in \(notificationDelay) seconds with uuid of: \(notificationUuid)")
        center.add(request)
        
    }
    
    func cancelScheduledNotification(notificationUuid: String) {
        let center = UNUserNotificationCenter.current()
        print("NotificationManager - cancelScheduledNotification - Cancelling notification for uuid: \(notificationUuid)")
        center.removePendingNotificationRequests(withIdentifiers: [notificationUuid])
    }
    
    func processNotificationReceivedWhilstInForeground(contentToLaunch: String, itemToLaunch: String, contentBody: String) {
        let currentViewController = UIApplication.topMostViewController
        
        if (String(describing: currentViewController.self).contains("VirtualCharacterConversationViewController") && contentToLaunch.contains("message")) {
        } else {
            let welcomeViewController = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController as! WelcomeViewController
            welcomeViewController.displayPopUp(contentToLaunch: contentToLaunch, itemToLaunch: itemToLaunch, contentBody: contentBody)
        }
        

        if (String(describing: currentViewController.self).contains("VirtualCharacterConversationViewController") && contentToLaunch.contains("message")) {
            let currentVirtualCharacterConversationViewController = currentViewController as! VirtualCharacterConversationViewController
            currentVirtualCharacterConversationViewController.viewDidLoad()
            
        } else if (String(describing: currentViewController.self).contains("VoicemailViewController") && contentToLaunch.contains("voicemail")) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let homeScreenViewControllerReference = appDelegate.homeScreenViewControllerReference
            if let homeScreenViewController = homeScreenViewControllerReference {
                homeScreenViewController.dismiss(animated: true, completion: { () in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let voicemailViewController = storyboard.instantiateViewController(withIdentifier: "voicemailViewControllerID") as! VoicemailViewController
                    voicemailViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    voicemailViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    homeScreenViewController.present(voicemailViewController, animated: true, completion: nil)})
            }
        }
    }
    
    
    func processClickedUponNotificationFromExternalNotification(contentToLaunch: String, itemToLaunch: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let homeScreenViewControllerReference = appDelegate.homeScreenViewControllerReference
        if contentToLaunch.contains("voicemail") {
            if let homeScreenViewController = homeScreenViewControllerReference {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let voicemailViewController = storyboard.instantiateViewController(withIdentifier: "voicemailViewControllerID") as! VoicemailViewController
                    voicemailViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    voicemailViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    homeScreenViewController.present(voicemailViewController, animated: true, completion: nil)//})
            }
        } else if contentToLaunch.contains("image") {
            print("Launching media app from notification")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mediaLibraryViewController = storyboard.instantiateViewController(withIdentifier: "mediaLibraryViewControllerID") as! MediaLibraryViewController
            mediaLibraryViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            // Display NotificationViewController
            UIApplication.topMostViewController?.present(mediaLibraryViewController, animated: true, completion: nil)
            mediaLibraryViewController.displaySpecificImageItem(selectedMediaItemName: itemToLaunch)
            
        } else if contentToLaunch.contains("video") {
            print("Launching media app from notification")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mediaLibraryViewController = storyboard.instantiateViewController(withIdentifier: "mediaLibraryViewControllerID") as! MediaLibraryViewController
            mediaLibraryViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            // Display NotificationViewController
            UIApplication.topMostViewController?.present(mediaLibraryViewController, animated: true, completion: nil)
            mediaLibraryViewController.displaySpecificVideoItem(selectedMediaItemName: itemToLaunch)
            
        } else if contentToLaunch.contains("message") {
            if let homeScreenViewController = homeScreenViewControllerReference {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let messagesNavigationController = storyboard.instantiateViewController(withIdentifier: "messagesNavigationController") as! UINavigationController
                    messagesNavigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    messagesNavigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    homeScreenViewController.present(messagesNavigationController, animated: true, completion: { () in
                        let messagesNavigationControllerChildren = messagesNavigationController.children
                        let virtualCharacterConversationListViewController = messagesNavigationControllerChildren[0] as! VirtualCharacterConversationListViewController
                        virtualCharacterConversationListViewController.openSpecifiedConversation(characterName: itemToLaunch) } ) //} )
            }
        }  else if contentToLaunch.contains("webbrowser") {
            if let homeScreenViewController = homeScreenViewControllerReference {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let webBrowserViewController = storyboard.instantiateViewController(withIdentifier: "webBrowserViewControllerID") as! WebBrowserViewController
                webBrowserViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                webBrowserViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                webBrowserViewController.selectedURL = itemToLaunch
                homeScreenViewController.present(webBrowserViewController, animated: true, completion: { () in
                } )
            }
        }
        
    }
    
    func processClickedUponNotificationFromInternalNotification(contentToLaunch: String, itemToLaunch: String) {
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let homeScreenViewControllerReference = appDelegate.homeScreenViewControllerReference
        
        if contentToLaunch.contains("voicemail") {
            if let homeScreenViewController = homeScreenViewControllerReference {
                homeScreenViewController.dismiss(animated: true, completion: { () in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let voicemailViewController = storyboard.instantiateViewController(withIdentifier: "voicemailViewControllerID") as! VoicemailViewController
                    voicemailViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    voicemailViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    homeScreenViewController.present(voicemailViewController, animated: true, completion: nil)})
            }
        } else if contentToLaunch.contains("image") {
            print("Launching media app from notification")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mediaLibraryViewController = storyboard.instantiateViewController(withIdentifier: "mediaLibraryViewControllerID") as! MediaLibraryViewController
            mediaLibraryViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            UIApplication.topMostViewController?.present(mediaLibraryViewController, animated: true, completion: nil)
            mediaLibraryViewController.displaySpecificImageItem(selectedMediaItemName: itemToLaunch)
            
        } else if contentToLaunch.contains("video") {
            print("Launching media app from notification")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mediaLibraryViewController = storyboard.instantiateViewController(withIdentifier: "mediaLibraryViewControllerID") as! MediaLibraryViewController
            mediaLibraryViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            UIApplication.topMostViewController?.present(mediaLibraryViewController, animated: true, completion: nil)
            mediaLibraryViewController.displaySpecificVideoItem(selectedMediaItemName: itemToLaunch)
            
        } else if contentToLaunch.contains("message") {
            if let homeScreenViewController = homeScreenViewControllerReference {
                homeScreenViewController.dismiss(animated: true, completion: { () in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let messagesNavigationController = storyboard.instantiateViewController(withIdentifier: "messagesNavigationController") as! UINavigationController
                    messagesNavigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    messagesNavigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    homeScreenViewController.present(messagesNavigationController, animated: true, completion: { () in
                        let messagesNavigationControllerChildren = messagesNavigationController.children
                        let virtualCharacterConversationListViewController = messagesNavigationControllerChildren[0] as! VirtualCharacterConversationListViewController
                        virtualCharacterConversationListViewController.openSpecifiedConversation(characterName: itemToLaunch) } ) } )
            }
        }
        else if contentToLaunch.contains("webbrowser") {
            if let homeScreenViewController = homeScreenViewControllerReference {
                homeScreenViewController.dismiss(animated: true, completion: { () in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let webBrowserViewController = storyboard.instantiateViewController(withIdentifier: "webBrowserViewControllerID") as! WebBrowserViewController
                    webBrowserViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    webBrowserViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    webBrowserViewController.selectedURL = itemToLaunch
                    homeScreenViewController.present(webBrowserViewController, animated: true, completion: { () in
                        
                    } ) } )
            }
        }
        
    }
    
    
    
}
