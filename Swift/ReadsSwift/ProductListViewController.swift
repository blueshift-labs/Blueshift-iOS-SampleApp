//
//  ProductListViewController.swift
//  ReadsSwift
//
//  Created by Ketan on 20/05/20.
//

import UIKit
import Kingfisher
import BlueShift_iOS_SDK

class ProductListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var locationManager: CLLocationManager?
    var roundButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
        registerForLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addFloatingButton()
    }
    
    func setupUI() {
        tableView.rowHeight = 120
        title = "Product List"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(showLogoutConfirmation))
        navigationItem.leftBarButtonItem = logoutButton
        
        roundButton = UIButton(type: .custom)
        roundButton.setTitleColor(UIColor.orange, for: .normal)
        roundButton.addTarget(self, action: #selector(showDebug), for: UIControl.Event.touchUpInside)
        view.addSubview(roundButton)
    }
    
    func setupEvents() {
        //Disable push notifications in AppDelegate config and Enable & register for push notifications here if need to ask the push permission after the login
        //        Utils.shared?.blueshift?.config.enablePushNotification = true
        //        Utils.shared?.blueshift?.appDelegate?.registerForNotification()
    }
    
    func addFloatingButton() {
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
        Utils.shared?.blueshift?.trackEvent(forEventName: "Logout", canBatchThisEvent: false)
        //Set enablePush to false so that the app will not receive any push notificaiton after logout. Fire identify after setting enablePush.
        BlueShiftAppData.current()?.enablePush = false
        Utils.shared?.blueshift?.identifyUser(withDetails: nil, canBatchThisEvent: false)
        //Reset userinfo after logout
        BlueShiftUserInfo.removeCurrentUserInfo()
        self.navigationController?.popToRootViewController(animated: true)
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
            cell.productImageView.kf.setImage(with: imageUrl)
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

