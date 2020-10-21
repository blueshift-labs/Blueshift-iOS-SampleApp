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
        if let _ = BlueShiftUserInfo.sharedInstance()?.email {
            showProductList(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForInApp = false
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUI() {
        title = "Sign In"
        signInButton.backgroundColor = self.themeColor
    }
        
    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        //Set email and customer id user info in the Blueshift SDK
        BlueShiftUserInfo.sharedInstance()?.email = emailIdTextField.text
        BlueShiftUserInfo.sharedInstance()?.retailerCustomerID = "PROFILEID:\(emailIdTextField.text ?? "")"
        
        //Set other user info as below. This info will be used for running personlised campaigns
        BlueShiftUserInfo.sharedInstance()?.firstName = nameTextField.text
//        BlueShiftUserInfo.sharedInstance()?.lastName = "add last name"
//        BlueShiftUserInfo.sharedInstance()?.gender = "add gender"
//        BlueShiftUserInfo.sharedInstance()?.dateOfBirth = "add DOB"
        
        //If want to store additional user information, you can create the dictionary and assign it to additionalUserInfo
        BlueShiftUserInfo.sharedInstance()?.additionalUserInfo = ["profession":"Software engineer", "phone_number": "+919898989898"]
        
        BlueShiftUserInfo.sharedInstance()?.save()
        
        //Set enablePush to true in case you have disabling it on the logout
        //By default its set to true for fresh app install
        BlueShiftAppData.current()?.enablePush = true
        
        //Add custom attributes to the identify call which will be shown against user profile in the dashboard
        let dictionary = ["userType":"Premium"]
        
        BlueShift.sharedInstance().identifyUser(withDetails:dictionary, canBatchThisEvent: false)
        
        //Add successful signin event
        BlueShift.sharedInstance().trackEvent(forEventName: "signIn", andParameters: nil, canBatchThisEvent: false)
        showProductList(animated: true)
    }
    
    func showProductList(animated: Bool) {
        let productListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductListViewController")
        self.navigationController?.pushViewController(productListViewController, animated: animated)
    }    
}

