//
//  ProductListViewController.swift
//  ReadsSwift
//
//  Created by Ketan on 20/05/20.
//

import UIKit
import BlueShift_iOS_SDK

class ProductListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var locationManager: CLLocationManager?
    var roundButton = UIButton()
    var lblBadge: UILabel?
    var token: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
        registerForLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set initial badge count
        BlueshiftInboxManager.getInboxUnreadMessagesCount({ [weak self] status, count in
            self?.lblBadge?.text = "\(count)"
        })
        
        //refersh badge count when on inbox data change
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name(kBSInboxUnreadMessageCountDidChange), object: nil, queue: OperationQueue.current) { Notification in
            BlueshiftInboxManager.getInboxUnreadMessagesCount({[weak self] status, count in
                self?.lblBadge?.text = "\(count)"
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(token!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        setPositionForFloatingButton()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        openCachedDeepLink()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupUI() {
        tableView.rowHeight = 120
        title = "Product List"
        addLogoutButton()
//        addDebugButton()
    }
    
    func addInboxButton() {
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        if #available(iOS 13.0, *) {
            filterBtn.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        filterBtn.addTarget(self, action: #selector(openInbox), for: .touchUpInside)
        
        lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 15, height: 15))
        lblBadge?.backgroundColor = UIColor.white
        lblBadge?.clipsToBounds = true
        lblBadge?.layer.cornerRadius = 7
        lblBadge?.textColor = UIColor.black
        lblBadge?.adjustsFontSizeToFitWidth = true
        lblBadge?.textAlignment = .center
        lblBadge?.text = "0"
        if let lbl = lblBadge {
            filterBtn.addSubview(lbl)
        }
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: filterBtn)]
    }
    
    func showInboxNavigationVC() {
        let inboxNavigationVC = BlueshiftInboxNavigationViewController(rootViewController: BlueshiftInboxViewController())
        inboxNavigationVC.refreshControlColor = themeColor
        inboxNavigationVC.unreadBadgeColor = themeColor
        inboxNavigationVC.activityIndicatorColor = themeColor
        inboxNavigationVC.inboxDelegate = MobileInboxDelegate()
        inboxNavigationVC.noMessagesText = "No messages available \n Check again later!"
        
        inboxNavigationVC.title = "Mobile Inbox"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        inboxNavigationVC.navigationBar.titleTextAttributes = textAttributes
        inboxNavigationVC.modalPresentationStyle = .fullScreen
        inboxNavigationVC.navigationBar.tintColor = UIColor.white
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = themeColor
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            inboxNavigationVC.navigationBar.standardAppearance = appearance
            inboxNavigationVC.navigationBar.scrollEdgeAppearance = appearance
        }
        
        self.present(inboxNavigationVC, animated:true, completion: nil)
    }
    
    @objc func openInbox() {
        showInboxNavigationVC()
    }
    
    func addDebugButton() {
        roundButton = UIButton(type: .custom)
        roundButton.setTitleColor(UIColor.orange, for: .normal)
        roundButton.addTarget(self, action: #selector(showDebug), for: UIControl.Event.touchUpInside)
        view.addSubview(roundButton)
    }
    
    func addLogoutButton() {
        if (BlueShiftUserInfo.sharedInstance()?.email != nil || BlueShiftUserInfo.sharedInstance()?.retailerCustomerID != nil) {
            let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(showLogoutConfirmation))
            navigationItem.leftBarButtonItem = logoutButton
        }
    }
    
    func openCachedDeepLink() {
        if let url = Utils.shared?.deepLinkURL {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showProductDetail(animated: true, url: url, options: [:])
                Utils.shared?.deepLinkURL = nil
            }
        }
    }
    
    func setupEvents() {
        if (BlueShift.sharedInstance()?.config?.enableMobileInbox == true) {
            addInboxButton()
        }
        //Disable push notifications in AppDelegate config and Enable & register for push notifications here if need to ask the push permission after the login
        BlueShift.sharedInstance()?.config?.enablePushNotification = true
        BlueShift.sharedInstance()?.appDelegate?.registerForNotification()
    }
    
    func setPositionForFloatingButton() {
        roundButton.layer.cornerRadius = 37.5
        roundButton.backgroundColor = themeColor
        roundButton.clipsToBounds = true
        roundButton.setTitle("Debug", for: .normal)
        roundButton.setTitleColor(.white, for: .normal)
        roundButton.showsTouchWhenHighlighted = true
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
        roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -25),
        roundButton.widthAnchor.constraint(equalToConstant: 75),
        roundButton.heightAnchor.constraint(equalToConstant: 75)])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails" {
            if let destinationVC = segue.destination as? ProductDetailViewController {
                destinationVC.product = sender as? [String : String]
            }
        }
    }
    
    func showProductDetail(animated: Bool, product: [String: String]) {
        performSegue(withIdentifier: "showProductDetails", sender: product)
    }
    
    @objc func showDebug() {
        performSegue(withIdentifier: "showDebug", sender: nil)
    }
    
    func registerForLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    @objc func showLogoutConfirmation() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.logout()
        }
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        BlueShift.sharedInstance()?.trackEvent(forEventName: "Logout", canBatchThisEvent: false)

        blueshiftLogout()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func blueshiftLogout() {
        //Set enablePush to false so that the app will not receive any push notificaiton after logout. Fire identify after setting enablePush.
        BlueShiftAppData.current().enablePush = false
        BlueShiftAppData.current().enableInApp = false
        
        // Send identify event with or without additonal details
        BlueShift.sharedInstance()?.identifyUser(withDetails: nil, canBatchThisEvent: false)
        
        // Reset userinfo
        BlueShiftUserInfo.removeCurrentUserInfo()
        
        // Reset device id and send identify, so that SDK will create a new device id.
        BlueShiftDeviceData.current().resetDeviceUUID()
 
//         Set enablePush and enableInApp to true for guest user and send identify
        BlueShiftAppData.current().enablePush = true
        BlueShiftAppData.current().enableInApp = true
        BlueShift.sharedInstance()?.identifyUser(withDetails: nil, canBatchThisEvent: false)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utils.shared?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = Utils.shared?.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCellIdentifier") as! ProductTableViewCell
        if let url = product?["image_url"], let imageUrl = URL(string: url) {
            DispatchQueue.global(qos: .userInteractive).async {
                let data = NSData.init(contentsOf: imageUrl)
                if let data = data as Data?, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        Utils.shared?.productImages[url] = image
                        cell.productImageView.image = image
                    }
                }
            }
        }
        cell.productSKULabel.text = product?["sku"]
        cell.productPriceLabel.text = "$" + (product?["price"] ?? "")
        cell.productTitleLabel.text = product?["name"]
        return cell
    }
    
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = Utils.shared?.products[indexPath.row]  else { return }
        showProductDetail(animated: true, product: product)
    }
}

extension ProductListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            BlueShiftDeviceData.current()?.currentLocation = location;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let location = manager.location {
            BlueShiftDeviceData.current()?.currentLocation = location
        }
    }
}

