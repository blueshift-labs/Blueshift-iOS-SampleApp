//
//  MobileInboxDelegate.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 17/11/22.
//

import Foundation
import BlueShift_iOS_SDK

class MobileInboxDelegate: NSObject, BlueshiftInboxViewControllerDelegate {
    var messageComparator: ((BlueshiftInboxMessage, BlueshiftInboxMessage) -> ComparisonResult)? = {msg1, msg2 in
    //Show unread messages on top
        if msg1.readStatus && !msg2.readStatus {
            return .orderedDescending
        } else {
            return .orderedAscending
        }
    }
    
    func formatDate(_ message: BlueshiftInboxMessage) -> String? {
        guard let createdAt = message.createdAtDate else {
            return nil
        }
        if #available(iOS 13.0, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: createdAt, relativeTo: Date())
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm aa"
            return dateFormatter.string(from: createdAt)
        }
    }
    
    // Handle deep link to show the deep link screen on inboxNavigationStack
    func inboxNotificationActionTapped(withDeepLink deepLink: String?, inboxViewController inboxVC: BlueshiftInboxViewController?, options: [String : Any] = [:]) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let product = appDelegate?.getProductForURL(url: deepLink ?? "")?.first, let navController = inboxVC?.navigationController {
            appDelegate?.showProductUsing(navigationController: navController, product: product, animated: true)
        }
    }
}
