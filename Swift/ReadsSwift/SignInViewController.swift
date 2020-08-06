//
//  SignInViewController.swift
//  ReadsSwift
//
//  Created by Ketan on 18/05/20.
//

import UIKit
import BlueShift_iOS_SDK

class SignInViewController: BaseViewController {
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func loadView() {
        super.loadView()
        if let _ = UserDefaults.standard.value(forKey: "BSFTemailId") {
            showProductList(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Sign In"
        BlueShift.sharedInstance().trackEvent(forEventName: String(describing: SignInViewController.self), andParameters: nil, canBatchThisEvent: true)
        self.registerForInApp = false
        signInButton.backgroundColor = self.themeColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BlueShift.sharedInstance()?.unregisterForInAppMessage()
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        //Make an identify call with the signed in user
        BlueShiftUserInfo.sharedInstance()?.email = emailIdTextField.text
        BlueShiftUserInfo.sharedInstance()?.retailerCustomerID = "PROFILEID:" + (emailIdTextField.text ?? "")
        BlueShiftUserInfo.sharedInstance()?.unsubscribed = false
        BlueShiftUserInfo.sharedInstance()?.save()
        let dictionary = ["name": nameTextField.text ?? "", "profession":"Software developer"]
        BlueShift.sharedInstance().identifyUser(withDetails:dictionary, canBatchThisEvent: false)
        
        //Add screen view event
        BlueShift.sharedInstance().trackEvent(forEventName: "signIn", andParameters: nil, canBatchThisEvent: false)
        if let email = emailIdTextField.text {
            UserDefaults.standard.setValue(email, forKey: "BSFTemailId")
        }
        showProductList(animated: true)
    }
    
    func showProductList(animated: Bool) {
        let productListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductListViewController")
        self.navigationController?.pushViewController(productListViewController, animated: animated)
    }    
}

