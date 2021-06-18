//
//  ProductDetailViewController.swift
//  ReadsSwift
//
//  Created by Ketan on 20/05/20.
//

import UIKit
import BlueShift_iOS_SDK

class ProductDetailViewController: BaseViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productSKULabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var addToWishListButton: UIButton!
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var goToCartButton: UIButton!
    
    var product: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
    }
    
    func setupUI() {
        title = product?["name"]
        if let url = product?["image_url"], let imageUrl = URL(string: url)  {
            productImageView.kf.setImage(with: imageUrl)
        }
        productTitleLabel.text = product?["name"]
        productPriceLabel.text = "$" + (product?["price"] ?? "")
        productSKULabel.text = product?["sku"]
        addToCartButton.backgroundColor = self.themeColor
        addToWishListButton.backgroundColor = self.themeColor
        safeAreaView.backgroundColor = self.themeColor
        goToCartButton.backgroundColor = self.themeColor
    }
    
    func setupEvents() {
        BlueShift.sharedInstance()?.trackProductViewed(withSKU: product?["sku"] ?? "", andCategoryID: 0, canBatchThisEvent: false)
    }
        
    @IBAction func addToCart(_ sender: Any) {
        BlueShift.sharedInstance()?.trackAddToCart(withSKU: product?["sku"] ?? "", andQuantity: 1, andParameters: product, canBatchThisEvent: false)
        for index in 0..<(Utils.shared?.cartItems.count ?? 0) {
            if Utils.shared?.cartItems[index].sku == product?["sku"] {
                Utils.shared?.cartItems[index].quantity += 1
                return
            }
        }
        
        Utils.shared?.cartItems.append(CartItem(sku: product?["sku"], quantity: 1, details: product))
    }
    
    @IBAction func addToWishList(_ sender: Any) {
        BlueShift.sharedInstance()?.trackEvent(forEventName: "add_to_wishlist", andParameters: product, canBatchThisEvent: false)
    }
    
    @IBAction func goToCart(_ sender: Any) {
        
    }
}

