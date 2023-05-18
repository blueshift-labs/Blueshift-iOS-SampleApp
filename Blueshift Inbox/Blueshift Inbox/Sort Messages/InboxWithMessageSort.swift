//
//  InboxWithMessageSort.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 11/01/23.
//

import Foundation
import BlueShift_iOS_SDK


/// If you want to sort the messages to display in custom order inside inbox based on your usecase, then you can implement
/// `BlueshiftInboxViewControllerDelegate` on a class and assign the delegate
/// to the `inboxDelegate` property during the Inbox initialisation.
///

extension ViewController {
    @IBAction private func showInboxWithMessageSort(_ sender: Any) {
        let navController = BlueshiftInboxNavigationViewController()
        navController.inboxDelegate = MessageSortInboxDelegate()
        navController.title = "Inbox with message sort"
        self.present(navController, animated:true, completion: nil)
    }
}

/// You will need to set comparator closure to the `messageComparator` variable.
/// The closure gets two `BlueshiftInboxMessage` objets for comparision and
/// it should return the `ComparisonResult` for the two messages.
/// Refer to below example to see how it works.
public class MessageSortInboxDelegate: NSObject, BlueshiftInboxViewControllerDelegate {

    public var messageComparator: ((BlueshiftInboxMessage, BlueshiftInboxMessage) -> ComparisonResult)? = {msg1, msg2 in
        
        //Sort messages based on message created date
        if let date1 = msg1.createdAtDate, let date2 = msg2.createdAtDate {
            //New Messages displayed on top
            return date2.compare(date1)
            
            //Old messages displayed on top
//            return date1.compare(date2)
        }
        
        
        
//        //Sort messages based on text
//        if let msg1Title = msg1.title, let msg2Title = msg2.title {
//            return msg1Title.caseInsensitiveCompare(msg2Title)
//        }
        
        
//        //Sort messages to show unread messages on the top
//            if msg1.readStatus && !msg2.readStatus {
//                return .orderedDescending
//            } else {
//                return .orderedAscending
//            }

        
        //Default return same order
        return .orderedSame
    }
}
