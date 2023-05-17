//
//  InboxUsingNavController.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 11/01/23.
//

/// Using this method, you can create the inbox using the navigation controller.
/// You can use this way to add the deep linked screen to the same navigation stack
/// and dismiss the navigation controller when the job is done.

import Foundation
import BlueShift_iOS_SDK

extension ViewController {
    @IBAction private func  showDefaultInboxUsingNavigationController(_ sender: Any) {
        //Create Blueshift inbox navigation controller object
        let navController = BlueshiftInboxNavigationViewController()
        //customization
        navController.unreadBadgeColor = UIColor.blue
        navController.refreshControlColor = UIColor.systemPink
        navController.title = "Default Inbox"
        navController.enableLargeTitle = true
        navController.showDoneButton = true
        navController.modalPresentationStyle = .fullScreen
        navController.inboxDelegate = HandleInboxInAppClickDelegate()
        //present 
        self.present(navController, animated:true, completion: nil)
    }
}

//Deep link handling
class HandleInboxInAppClickDelegate: NSObject, BlueshiftInboxViewControllerDelegate {
    func inboxNotificationActionTapped(withDeepLink deepLink: String?, inboxViewController inboxVC: BlueshiftInboxViewController?, options: [String : Any] = [:]) {
        //handle inbox originated in-app notification deep links
        let vc = UIViewController()
        vc.title = "Deep link screen"
        vc.view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: vc.view.frame.size.width - 50, height: 400))
        label.text = deepLink
        label.textColor = .black
        
        label.center = vc.view.center
        label.numberOfLines = 0
        vc.view.addSubview(label)
        inboxVC?.navigationController?.show(vc, sender: nil)
    }
}
