//
//  MultipleCellsInboxDelegate.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 11/01/23.
//

import Foundation
import BlueShift_iOS_SDK

public class MultipleCellsInboxDelegate: NSObject, BlueshiftInboxViewControllerDelegate {
    public var customCellNibNames: [String]? = ["OfferInboxTableViewCell", "CustomInboxTableViewCell"]
    
   public func getCustomCellNibName(for message: BlueshiftInboxMessage) -> String? {
       if message.title!.contains("1") || message.title!.contains("3") {
           return "OfferInboxTableViewCell"
       } else if message.title!.contains("2") || message.title!.contains("5") {
           return "CustomInboxTableViewCell"
       } else {
           return nil
       }
    }
}

extension ViewController {
    
    
}
