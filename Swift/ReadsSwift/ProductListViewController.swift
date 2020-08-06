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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 120
        title = "Product List"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        BlueShift.sharedInstance().trackEvent(forEventName: String(describing: ProductListViewController.self), andParameters: nil, canBatchThisEvent: true)
        
        //Disable push notifications in AppDelegate config and Enable & register for push notifications here if need to ask the push permission after the login
//        BlueShift.sharedInstance()?.config.enablePushNotification = true
//        BlueShift.sharedInstance()?.appDelegate.registerForNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func showProductDetail(animated: Bool, product: [String: String]) {
        let productDetailViewController: ProductDetailViewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductDetailViewController")
        productDetailViewController.product = product
        self.navigationController?.pushViewController(productDetailViewController, animated: animated)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utils.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = Utils.shared.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCellIdentifier") as! ProductTableViewCell
        if let url = product["image_url"], let imageUrl = URL(string: url) {
            cell.productImageView.kf.setImage(with: imageUrl)
        }
        cell.productSKULabel.text = product["sku"]
        cell.productPriceLabel.text = "$" + (product["price"] ?? "")
        cell.productTitleLabel.text = product["name"]
        return cell
    }
    
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = Utils.shared.products[indexPath.row]
        showProductDetail(animated: true, product: product)
    }
}
