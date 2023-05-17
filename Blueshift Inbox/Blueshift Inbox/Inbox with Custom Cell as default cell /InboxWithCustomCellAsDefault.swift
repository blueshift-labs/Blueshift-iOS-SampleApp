//
//  InboxWithCustomCellAsDefault.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 11/01/23.
//

import Foundation
import BlueShift_iOS_SDK

/// Instead of using a default SDK provided layout for inbox cell, you can use a custom layout as default layout for your inbox cell, and to do that make a copy of the  SDK's `BlueshiftInboxTableViewCell.xib` file
/// in your project and rename it to give custom name. Now you can customise the UI based on your requirement.
/// Create assiciated class for the tableViewCell, give the same name as the custom xib name.
/// Make sure the custom inbox cell class inherits `BlueshiftInboxTableViewCell`.
/// While initialising the Inbox screen, you need to set the `customCellNibName` property
/// and provide the name your custom cell layout xib.

extension ViewController {
    @IBAction private func showInboxWithCustomCellAsDefaultCell(_ sender: Any) {
        let navController = BlueshiftInboxNavigationViewController()
        navController.customCellNibName = "CustomInboxTableViewCell"
        navController.title = "Custom cell Inbox"
        self.present(navController, animated:true, completion: nil)
    }
}
