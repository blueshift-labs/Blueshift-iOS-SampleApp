//
//  InboxWithMessageFilter.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 11/01/23.
//

import Foundation
import BlueShift_iOS_SDK


/// If you want to filter the messages displayed inside the inbox screen, then you can implement
/// `BlueshiftInboxViewControllerDelegate` on a class and assign the delegate
/// to the `inboxDelegate` property during the Inbox initialisation.

extension ViewController {
    @IBAction private func showInboxWithMessageFilter(_ sender:Any) {
        let navController = BlueshiftInboxNavigationViewController()
        navController.inboxDelegate = MessageFilterInboxDelgate()
        navController.title = "Inbox with message filter"
        self.present(navController, animated:true, completion: nil)
    }
}

/// You will need to set closure to the `messageFilter` variable.
/// The closure gets the `BlueshiftInboxMessage` objet for filtering out the messages based on your custom usecase
/// and return true or false for that messages.
public class MessageFilterInboxDelgate: NSObject, BlueshiftInboxViewControllerDelegate {
    // Filter to show only Unread messages
    public var messageFilter: ((BlueshiftInboxMessage) -> Bool)? = { message in
        return !message.readStatus
    }
}
