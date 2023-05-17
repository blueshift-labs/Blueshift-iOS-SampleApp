//
//  CustomDateFormat.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 11/01/23.
//

import Foundation
import BlueShift_iOS_SDK

/// If you want to have your own custom date format for the Inbox, then you can implement
/// `BlueshiftInboxViewControllerDelegate` on a class and assign the delegate
/// to the `inboxDelegate` property during the Inbox initialisation.
///

extension ViewController {
    @IBAction private func showInboxWithCustomDateFormat(_ sender: Any) {
        let navController = BlueshiftInboxNavigationViewController()
        navController.inboxDelegate = CustomDateFormatterInboxDelegate()
        navController.title = "Inbox with Date format"
        self.present(navController, animated:true, completion: nil)
    }
}


/// Implement the method `formatDate()` from the `BlueshiftInboxViewControllerDelegate` to give
/// custom implementation to the date formatting.
/// This method will provide the `BlueshiftInboxMessage` and you have to return the formatted date in the
/// `String` format based on your usecase.
public class CustomDateFormatterInboxDelegate: NSObject, BlueshiftInboxViewControllerDelegate {
    
    public func formatDate(_ message: BlueshiftInboxMessage) -> String? {
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
}
