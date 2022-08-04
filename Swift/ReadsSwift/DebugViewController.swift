//
//  DebugViewController.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 13/10/20.
//

import UIKit
import BlueShift_iOS_SDK

class DebugViewController: BaseViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var inAppRegisterSwitch: UISwitch!
    var pushObserver:Any?
    
    //To execute these push/in-app sends for testing, you will need to setup event based campaigns on basis of below "bsft_send_me_*" events. Then only this will work.
    let events: [[String:String]] = [
                                     ["Register for push notification":"registerForPush"],
                                     ["Fetch in-app notifications":"fetchInApp"],
                                     ["Send Slide-in in-app message":"bsft_send_me_in_app"],
                                     ["Send HTML in-app message":"bsft_send_me_in_app_html"],
                                     ["Send Modal in-app message":"bsft_send_me_in_app_modal"],
                                     ["Send Title+Content push notification":"bsft_send_me_push"],
                                     ["Send Image push notification":"bsft_send_me_image_push"],
                                     ["Send Animated Carousel push notification":"bsft_send_me_animated_carousel_push"],
                                     ["Send Non animated Carousel push notification":"bsft_send_me_nonanimated_carousel_push"],
                                     ["Send custom buttons push notification":"bsft_send_me_custom_button_push"],
                                     ["Fire Identify event":"identify"],
                                     ["Fire app open event":"appOpen"],
                                     ["Fire multiple events":"fireMultipleEvents"],
                                     ["Fire 100 batched event":"fireBatchedEvents"],
                                     ["Disable SDK tracking":"disableSDKTracking"],
                                     ["Disable SDK tracking without erase":"disableSDKTrackingNoErase"],
                                     ["Enable SDK tracking":"enableSDKTracking"],
                                     ["Test in-app payload":"testInAppAPIPayload"],
                                     ["Test realtime events":"realtimeEvents"],
                                     ["Test custom event payload":"customEventPayload"],
                                     ["Unsubscribe Push":"unsubscribe"],
                                     ["Send me email":"bsft_send_me_ul_email"],
                                     ["show Banner In App using Custom JSON":"showInAppWithCustomJSON"]
                                    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObserver()
       // fireEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let pushObserver = pushObserver {
            NotificationCenter.default.removeObserver(pushObserver)
        }
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = footerView
        footerView.backgroundColor = self.themeColor
        tableView.rowHeight = UITableView.automaticDimension
        title = "Debug"
        inAppRegisterSwitch.isOn = false
        self.registerForInApp = false
    }
    
    func setupObserver() {
        pushObserver = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "BlueshiftPushAuthorizationStatusDidChangeNotification"), object: nil, queue: OperationQueue.current) { notification in
            print("Push permission status : \(String(describing: notification.userInfo?["status"]))")
        }
    }

    @IBAction func registerForInApp(_ sender: Any) {
        guard let inAppSwitch = sender as? UISwitch else {
            return
        }
        if inAppSwitch.isOn {
            BlueShift.sharedInstance()?.registerFor(inAppMessage:  String(describing: type(of: self)))
        } else {
            BlueShift.sharedInstance()?.unregisterForInAppMessage()
        }
    }
    
    @IBAction func showLiveContent(_ sender: Any) {
        performSegue(withIdentifier: "showLiveContent", sender: nil)
    }
}
extension DebugViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:DebugTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DebugTableViewCellIdentifier", for: indexPath) as? DebugTableViewCell else {
            
            return UITableViewCell()
        }
        cell.titleLabel.text = events[indexPath.row].keys.first
        return cell
    }
}

extension DebugViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = events[indexPath.row].values.first {
            switch event {
            case "appOpen":
                BlueShift.sharedInstance()?.appDelegate?.trackAppOpen(withParameters: nil)
            case "identify":
                BlueShift.sharedInstance()?.identifyUser(withDetails: nil, canBatchThisEvent: false)
            case "fetchInApp":
                BlueShift.sharedInstance()?.fetchInAppNotification(fromAPI: {
                    
                }, failure: { err in
                        print("hello there \(String(describing: err))")
                });
            case "fireBatchedEvents":
                for index in 0...100 {
                    BlueShift.sharedInstance()?.trackEvent(forEventName: "BatchedEvent_\(index)", canBatchThisEvent: true)
                }
            case "registerForPush":
                BlueShift.sharedInstance()?.appDelegate?.registerForNotification()
            case "disableSDKTracking":
                BlueShift.sharedInstance()?.enableTracking(false)
            case "disableSDKTrackingNoErase":
                BlueShift.sharedInstance()?.enableTracking(false, andEraseNonSyncedData: false)
            case "enableSDKTracking":
                BlueShift.sharedInstance()?.enableTracking(true)
            case "testInAppAPIPayload":
                testInAppAPIPayload()
            case "fireMultipleEvents":
                fireMultipleEvents();
            case "realtimeEvents":
                BlueShift.sharedInstance()?.trackInAppNotificationShowing(withParameter: ["bsft_experiment_uuid":"06b90250-0f12-863e-1b85-7424f6b22dc4","bsft_message_uuid":"f5169285-6763-4280-8fc1-a5259ffb5d92","bsft_transaction_uuid":"e75fd17c-ee5e-4fe5-a6c8-a59de4326b0c","bsft_user_uuid":"d45190de-a6a5-49cc-a0c2-8006de79b21c"], canBacthThisEvent: false)
            case "customEventPayload":
                BlueShift.sharedInstance()?.trackEvent(forEventName: "CustomEventWithPayload", andParameters: ["enable_inapp":false,"enable_push":false,"build_number":200], canBatchThisEvent: false)
            case "unsubscribe":
                BlueShiftUserInfo.sharedInstance()?.unsubscribed = (BlueShiftUserInfo.sharedInstance()?.unsubscribed == true) ? false : true
                BlueShiftUserInfo.sharedInstance()?.save()
            case "showInAppWithCustomJSON":
                showInAppWithCustomJSON()
            default:
                BlueShift.sharedInstance()?.trackEvent(forEventName: event, canBatchThisEvent: false)
            }
        }
    }
    
    func fireMultipleEvents() {
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_0", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_1", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_2", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_3", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_4", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_5", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_6", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_7", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_8", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackEvent(forEventName: "realtimeEvent_9", canBatchThisEvent: false)
        fireEvents()
    }
}

extension DebugViewController {
    func testInAppAPIPayload() {
        //        BlueShift.sharedInstance()?.getInAppNotificationAPIPayload(completionHandler: { (params) in
        //            let url = URL(string: kBaseURL + BlueShift_iOS_SDK.kInAppMessageURL)
        //            if let url = url, let payload = params {
        //                var request = URLRequest(url: url)
        //                let base64 = BlueShift.sharedInstance()?.config?.apiKey.data(using: .utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        //                request.httpMethod = "POST"
        //                request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        //                let config = URLSessionConfiguration.default
        //                config.httpAdditionalHeaders = ["Authorization":base64 ?? "","Content-Type":"application/json"]
        //                let session = URLSession.init(configuration: config)
        //                let task = session.dataTask(with: request) { (data, response, error) in
        //                    if let data = data {
        //                        let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
        //                        if let dictonary = dict as? [AnyHashable:Any] {
        //                        BlueShift.sharedInstance()?.handleInAppMessage(forAPIResponse: dictonary, withCompletionHandler: { (status) in
        //
        //                        })
        //                            BlueShift.sharedInstance()?.getInAppNotificationAPIPayload(completionHandler: { (payload) in
        //                                //do something
        //                            })
        //                        }
        //                    }
        //                }
        //                task.resume()
        //            }
        //        })
    }
    
    func fireEvents() {
        BlueShift.sharedInstance()?.trackEvent(forEventName: "custom event", canBatchThisEvent: false)
        BlueShift.sharedInstance()?.identifyUser(withEmail: BlueShiftUserInfo.sharedInstance()?.email ?? "", andDetails: nil, canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackScreenViewed(for: self, canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackProductViewed(withSKU: "JHBAHSDF622", andCategoryID:1234 , withParameter: nil, canBatchThisEvent: false)
        BlueShift.sharedInstance()?.trackAddToCart(withSKU: "JHBAHSDF622", andQuantity: 5, canBatchThisEvent: false)
        
        let product1 = BlueShiftProduct()
        product1.sku = "PRM123"
        product1.price = 50
        product1.quantity = 2
        
        let product2 = BlueShiftProduct()
        product2.sku = "PRM123"
        product2.price = 50
        product2.quantity = 2
        
        let product3 = BlueShiftProduct()
        product3.sku = "PRM123"
        product3.price = 50
        product3.quantity = 2
        
        let products = [product1, product2, product3]
                
        BlueShift.sharedInstance()?.trackCheckOutCart(withProducts: products, andRevenue: 123, andDiscount: 1, andCoupon: "coupon", canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackProductsPurchased(products, withOrderID: "123123", andRevenue: 123, andShippingCost: 1, andDiscount: 1, andCoupon: "coupon", canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackPurchaseCancel(forOrderID: "123123", canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackPurchaseReturn(forOrderID: "123123", andProducts: products, canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackProductSearch(withSkuArray: ["PRM123","PRM1234","PRM12345"], andNumberOfResults: 3, andPageNumber: 1, andQuery: "PRM", andParameters: nil, canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackEmailListSubscription(forEmail: BlueShiftUserInfo.sharedInstance()?.email ?? "", canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackEmailListUnsubscription(forEmail: BlueShiftUserInfo.sharedInstance()?.email ?? "", canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackSubscriptionInitialization(for: BlueShiftSubscriptionStateStart, andCycleType: "Anual", andCycleLength: 1, andSubscriptionType: "premium", andPrice: 100, andStartDate: Date().timeIntervalSince1970, canBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackSubscriptionPause(withBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackSubscriptionUnpause(withBatchThisEvent: false)
        
        BlueShift.sharedInstance()?.trackSubscriptionCancel(withBatchThisEvent: false)
    }
    
    func showInAppWithCustomJSON() {
        guard let data = loadJson(filename: "InApp") else { return }
        BlueShift.sharedInstance()?.handleInAppMessage(forAPIResponse: data, withCompletionHandler: { val in
            
        })
    }
    
    func loadJson(filename fileName: String) -> [String: Any]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                var jsonString = String(data: data, encoding: String.Encoding.utf8)
                jsonString = jsonString?.replacingOccurrences(of: "$$$$", with: String(format:"%f", NSDate().timeIntervalSince1970))
                let object = try JSONSerialization.jsonObject(with: jsonString?.data(using: String.Encoding.utf8) ?? Data(), options: .allowFragments)
                if let dictionary = object as? [String: Any] {
                    return dictionary
                }
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
        }
        return nil
    }
}

