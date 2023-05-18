//
//  CustomThemeInboxViewController.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 21/04/23.
//

// This example is to demonstrate how you can create inbox screen by your own.
// For case like when you want use your custom themed inbox UI, you can follow this approach.
// SDK provides set of methods using you can build your own inbox screen.
// This is sample example for cutom themed inbox screen.


import UIKit
import BlueShift_iOS_SDK

class CustomThemeInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var viewmodel: BlueshiftInboxViewModel?
    let cellIdentifier = "CustomThemeInboxTableViewCellIdentifier"
    var activityIndicatorView: UIActivityIndicatorView?
    var inAppNotificationDidAppear: NSObjectProtocol?
    var inboxUnreadMessageCountDidChange: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupActivityIndicator()
        setupTableView()
        //Sync inbox on load
        syncInbox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Fetch local cached data and show in inbox tableview
        setupObservers()
        reloadTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let inAppNotificationDidAppear = inAppNotificationDidAppear {
            NotificationCenter.default.removeObserver(inAppNotificationDidAppear)
        }
        if let inboxUnreadMessageCountDidChange = inboxUnreadMessageCountDidChange {
            NotificationCenter.default.removeObserver(inboxUnreadMessageCountDidChange)
        }
    }
    
    func setupViewModel() {
        viewmodel = BlueshiftInboxViewModel()
        //Sort the messages to show unread messages on the top
        viewmodel?.messageComparator = {msg1, msg2 in
            if msg1.readStatus && !msg2.readStatus {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        }
        
        //Set message filter to filter the messages displayed on the screen
        //Using below filter it will only show the unread messages in the inbox
//        viewmodel?.messageFilter = { message in
//            return !message.readStatus
//        }
    }
    
    func setupObservers() {
        //Add obserber to listen to inbox sync changes.
        //In case if you add pull to refresh, then you can stop the refreshAnimation in this observer
        inboxUnreadMessageCountDidChange = NotificationCenter.default.addObserver(forName: NSNotification.Name(kBSInboxUnreadMessageCountDidChange), object: nil, queue: OperationQueue.main) { [weak self] notification in
            if BlueshiftInboxChangeType.sync.rawValue == notification.userInfo?[kBSInboxRefreshType] as? UInt {
                self?.reloadTableView()
            }
        }
        //Add obserber to listen to stop activity indicator when notification is displayed
        inAppNotificationDidAppear = NotificationCenter.default.addObserver(forName: NSNotification.Name(kBSInAppNotificationDidAppear), object: nil, queue: OperationQueue.main) { [weak self] notification in
            self?.activityIndicatorView?.stopAnimating()
        }
    }
    
    func setupActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView?.color = .white
        if let activityIndicatorView = activityIndicatorView {
            view.addSubview(activityIndicatorView)
            activityIndicatorView.center = view.center
        }
    }
    
    func setupTableView() {
        self.title = "Custom Inbox"
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        //If you want to use mutliple cells, you can register them all here
        //Register custom tableviewcell
        tableView.register(UINib(nibName: "CustomThemeInboxTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
    }
    
    func syncInbox() {
        BlueshiftInboxManager.syncInboxMessages {
            //the tableview refresh will be taken care by the added observer
        }
    }
    
    func reloadTableView() {
        //Reload cached notifications and show in tableview
        viewmodel?.reloadInboxMessages(handler: { [weak self] isRefresh in
            if isRefresh {
                self?.tableView.reloadData()
            }
        })
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewmodel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel?.numberOfItems(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createTableViewCellFor(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectRowAt(indexPath: indexPath)
    }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            handleDeleteMessageAt(indexPath: indexPath)
        }
    }
}

extension CustomThemeInboxViewController {
    func createTableViewCellFor(indexPath: IndexPath) -> UITableViewCell {
        let message: BlueshiftInboxMessage? = viewmodel?.item(at: indexPath) ?? nil
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BlueshiftInboxTableViewCell
        if let inboxCell = cell {
            inboxCell.titleLabel.text = message?.title
            inboxCell.detailLabel.text = message?.detail
            inboxCell.dateLabel.text = viewmodel?.getDefaultFormatDate(message?.createdAtDate ?? Date())
            inboxCell.setIconImageURL(message?.iconImageURL ?? nil)
            inboxCell.unreadBadgeView.isHidden = message?.readStatus ?? false
            return inboxCell
        }
        return UITableViewCell()
    }
    
    func handleDidSelectRowAt(indexPath: IndexPath) {
        let message: BlueshiftInboxMessage = viewmodel?.item(at: indexPath) ?? BlueshiftInboxMessage()
        self.activityIndicatorView?.startAnimating()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        BlueshiftInboxManager.showNotification(for: message, inboxInAppDelegate: self);
    }
    
    func handleDeleteMessageAt(indexPath: IndexPath) {
        let message: BlueshiftInboxMessage? = viewmodel?.item(at: indexPath) ?? nil
        BlueshiftInboxManager.delete(message) { [weak self] status, errorMessage  in
            DispatchQueue.main.async {
                if status {
                    self?.reloadTableView()
                } else {
                    let alert = UIAlertController(title: "Failed to delete message!", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
                    self?.navigationController?.present(alert, animated: true)
                }
            }
        }
    }
}

// Make sure you implement the `BlueshiftInboxInAppNotificationDelegate` protocol
// even if you dont add implementation for any of its methods.
extension CustomThemeInboxViewController: BlueshiftInboxInAppNotificationDelegate {
    //custom deep link handling by overriding default deep link behaviour
    func inboxInAppNotificationActionTapped(withDeepLink deepLink: String?, options: [String : Any] = [:]) {
        //handle inbox originated in-app notification deep links
        let vc = UIViewController()
        vc.title = "Deep link screen"
        vc.view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: vc.view.frame.size.width - 50, height: 400))
        label.text = deepLink
        label.textColor = .black

        label.center = vc.view.center
        label.numberOfLines = 0
        vc.view.addSubview(label)
        self.show(vc, sender: nil)
    }

    func isInboxNotificationActionTappedImplementedByHostApp() -> Bool {
        return true
    }

    func getInboxWindowScene() -> UIWindowScene? {
        return view.window?.windowScene
    }
}
