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
        setEvents()
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
    
    func setEvents() {
        BlueShift.sharedInstance().trackEvent(forEventName: String(describing: ProductDetailViewController.self), andParameters: product, canBatchThisEvent: true)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
    }
    
    @IBAction func addToWishList(_ sender: Any) {
        
    }
    
    @IBAction func goToCart(_ sender: Any) {
        
    }
}
