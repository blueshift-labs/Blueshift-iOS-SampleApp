//
//  LiveContentViewController.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 12/11/20.
//

import UIKit
import BlueShift_iOS_SDK
import SafariServices
import WebKit

class LiveContentViewController: BaseViewController {

    @IBOutlet weak var slotTextBox: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var idSegmentControl: UISegmentedControl!
    @IBOutlet weak var idTextBox: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        registerForInApp = false
        slotTextBox.text = "careinappmessagingslot"
        contentTextView.text = ""
        idTextBox.text = BlueShiftUserInfo.sharedInstance()?.email
        webView.isHidden = true
    }
    
    @IBAction func getLiveContent(_ sender: Any) {
        let context: [String:String] = ["seed_item_ids":"9780307273482"];
        contentTextView.text = ""
        switch idSegmentControl.selectedSegmentIndex {
        case 0:
            BlueShiftLiveContent.fetch(byEmail: slotTextBox.text, withContext: context) { [self] (data) in
                self.showContentOnSuccess(data: data)
            } failure: { [self] (err) in
                self.showContentOnFailure()
            }

        case 1:
            BlueShiftLiveContent.fetch(byDeviceID: slotTextBox.text, withContext: context) { [self] (data) in
                self.showContentOnSuccess(data: data)
            } failure: { [self] (err) in
                self.showContentOnFailure()
            }
        case 2:
            BlueShiftLiveContent.fetch(byCustomerID: slotTextBox.text, withContext: context) { [self] (data) in
                self.showContentOnSuccess(data: data)
            } failure: { [self] (err) in
                self.showContentOnFailure()
            }
        default:
            break
        }
    }
    
    @IBAction func onSlotChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            idTextBox.text = BlueShiftUserInfo.sharedInstance()?.email
        case 1:
            idTextBox.text = BlueShiftDeviceData.current()?.deviceUUID
        case 2:
            idTextBox.text = BlueShiftUserInfo.sharedInstance()?.retailerCustomerID
        default:
            break
        }
    }
    
    @IBAction func onViewTap(_ sender: Any) {
        if webView.isHidden == false {
            webView.isHidden = true
        }
    }
    
    func showContentOnSuccess(data: [AnyHashable:Any]?) {
        if let data = data {
            contentTextView.text = "\(data)"
            if let content = data["content"] as? [AnyHashable:Any], let html = content["html_content"] as? String {
                webView.loadHTMLString(html, baseURL: nil)
                webView.isHidden = false
            }
        } else {
            showContentOnFailure()
        }
    }
    
    func showContentOnFailure() {
        contentTextView.text = "Failed to load data"
    }
}
