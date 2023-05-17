//
//  CartViewController.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 23/07/20.
//

import UIKit
import BlueShift_iOS_SDK

class CartViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emptyCartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "Cart"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        emailLabel.text = BlueShiftUserInfo.sharedInstance()?.email
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = false
        refreshTableView()
        checkoutButton.backgroundColor = themeColor
        checkoutView.backgroundColor = themeColor
    }
    
    func checkCartEmpty() {
        if Utils.shared?.cartItems.count ?? 0 > 0 {
            tableView.isHidden = false
            emptyCartLabel.isHidden = true
        } else {
            tableView.isHidden = true
            emptyCartLabel.isHidden = false
        }
    }
    
    func removeItem(index: Int) {
        Utils.shared?.cartItems.remove(at: index)
        refreshTableView()
    }
    
    func refreshCalculations() {
        var quantiy:Int = 0
        var amount:Double = 0
        for item in Utils.shared?.cartItems ?? [] {
            quantiy += item.quantity
            if let amt = item.details?["price"] {
                amount += Double(amt) ?? 0
            }
        }
        quantityLabel.text = "\(quantiy)"
        amountLabel.text = "$\(amount)"
    }
    
    func refreshTableView() {
        tableView.reloadData()
        checkCartEmpty()
        refreshCalculations()
    }
    
    @IBAction func checkout(_ sender: Any) {
        var products:[BlueShiftProduct] = []
        var amout:Float = 0.0
        for item in Utils.shared?.cartItems ?? [] {
            let product = BlueShiftProduct()
            if let amt = item.details?["price"] {
                product.price = Float(amt) ?? 0
                amout += product.price
            }
            product.quantity = item.quantity
            product.sku = item.sku
            products.append(product)
        }
        BlueShift.sharedInstance()?.trackCheckOutCart(withProducts: products, andRevenue: amout, andDiscount: 0, andCoupon: "New User", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackProductsPurchased(products, withOrderID: "order\(NSDate().timeIntervalSince1970)", andRevenue: amout, andShippingCost: 20, andDiscount: 0, andCoupon: "", canBatchThisEvent: false)
        Utils.shared?.cartItems.removeAll()
        refreshTableView()
        (UIApplication.shared.delegate as? AppDelegate)?.showAlert(for: "Order has been placed!", message: nil, viewController: self);
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utils.shared?.cartItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCellIdentifier", for: indexPath)  as? CartTableViewCell else {
            return UITableViewCell()
        }
        cell.skuLabel.text = Utils.shared?.cartItems[indexPath.row].sku
        cell.priceLabel.text = "$" + (Utils.shared?.cartItems[indexPath.row].details?["price"] ?? "")
        cell.productLabel.text = Utils.shared?.cartItems[indexPath.row].details?["name"]
        if let url = Utils.shared?.cartItems[indexPath.row].details?["image_url"], let _ = URL(string: url)  {
            cell.imageView?.image = Utils.shared?.productImages[url]
        }
        cell.quantityLabel.text = String(describing: Utils.shared?.cartItems[indexPath.row].quantity ?? 0)
        return cell;
    }
}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItem(index: indexPath.row)
        }
    }
}
