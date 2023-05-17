//
//  ViewController.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 10/01/23.
//

import UIKit
import BlueShift_iOS_SDK

class ViewController: UIViewController {
    let inboxOptions:[String] = ["SimpleInbox"]
    var badgeLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addInboxBadgeButton()
        updateUnreadMessageCount()
        setupObservers()
    }
    
    func updateUnreadMessageCount() {
        // Fetch inbox unread message count when screen is loaded to set to initial inbox badge count
        BlueshiftInboxManager.getInboxUnreadMessagesCount({ [weak self] status, count in
            if status {
                self?.badgeLabel?.text = "\(count)"
            }
        })
    }
    
    //Set observers to update the unread message badge count
    func setupObservers() {
        //Setup observer to listen to new in-app message changes and refresh the unread message count
        NotificationCenter.default.addObserver(forName: NSNotification.Name(kBSInboxUnreadMessageCountDidChange), object: nil, queue: OperationQueue.current) { [weak self] _ in
            self?.updateUnreadMessageCount()
        }
    }
    
    func addInboxBadgeButton() {
        let inboxButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        inboxButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        inboxButton.addTarget(self, action: #selector(openDefaultInbox), for: .touchUpInside)
        
        badgeLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 16, height: 16))
        badgeLabel?.backgroundColor = inboxButton.tintColor
        badgeLabel?.clipsToBounds = true
        badgeLabel?.layer.cornerRadius = 8
        badgeLabel?.textColor = UIColor.white
        badgeLabel?.adjustsFontSizeToFitWidth = true
        badgeLabel?.textAlignment = .center
        badgeLabel?.text = "0"
        if let lbl = badgeLabel {
            inboxButton.addSubview(lbl)
        }
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: inboxButton)]
    }
    
    @objc func openDefaultInbox() {
        showDefaultInboxUsingCode(nil)
    }
    
    
    /// Using this method, you can create the inbox using the inboxViewController.
    @IBAction func showDefaultInboxUsingCode(_ sender: Any?) {
        let inboxVC = BlueshiftInboxViewController()        
        //Customization
        inboxVC.unreadBadgeColor = UIColor.purple
        inboxVC.refreshControl?.tintColor = UIColor.red
        inboxVC.activityIndicatorColor = UIColor.blue
        inboxVC.title = "Default Inbox Using Code"
        inboxVC.noMessagesText = "No messages availble \n Come back later!"
        self.navigationController?.show(inboxVC, sender: nil)
    }
}

