//
//  CartViewController.swift
//  loblawCodingChallenge
//
//  Created by tommytexter on 2021-02-06.
//

import UIKit
import Foundation
import SDWebImage

class CartListViewController: UITableViewController {
    private var cartViewModel: CartListViewModelInterface
    private let networkErroralert = UIAlertController(title: LoblawConstants.AlertErrorMsg.errorTitle,
                                                      message: LoblawConstants.AlertErrorMsg.networkError,
                                                   preferredStyle: .alert)
    private let apiErrorAlert = UIAlertController(title: LoblawConstants.AlertErrorMsg.errorTitle,
                                                  message: LoblawConstants.AlertErrorMsg.serverError,
                                                  preferredStyle: .alert)
    
    
    init(viewModel: CartListViewModelInterface) {
        self.cartViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = UIColor.gray
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 0
        title = LoblawConstants.ViewContollerTitle.cartListViewControllerTitle
        
        cartViewModel.delegate = self
        cartViewModel.requestCartInfo()
        
        networkErroralert.addAction(UIAlertAction(title: LoblawConstants.AlertErrorMsg.retry,
                                                  style: .default,
                                                  handler: { [weak self] (action) in
                                                    self?.cartViewModel.requestCartInfo()}))
        
        networkErroralert.addAction(UIAlertAction(title: LoblawConstants.AlertErrorMsg.cancel,
                                                  style: .default,
                                                  handler: nil))
        
        apiErrorAlert.addAction(UIAlertAction(title: LoblawConstants.AlertErrorMsg.exit,
                                              style: .default,
                                              handler: { _ in exit(2)}))
    }
    // MARK: - UITableView Lifecycle
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.getProductCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let name = cartViewModel.getProductName(index: row)
        let imageUrl = cartViewModel.getProductImageURL(index: row)
        
        // Configure Cell
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loblawCell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "loblawCell")
            }
            return cell
        }()
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont(name: LoblawConstants.Text.cartListViewTextFont, size: LoblawConstants.Text.cartListViewTextSize)
        cell.textLabel?.text = name
        cell.imageView?.sd_setImage(with: URL(string: imageUrl),
                                    placeholderImage: UIImage(named: LoblawConstants.ImageService.placeHolderImageName),
                                    options: [.continueInBackground],
                                    completed: { [weak self] (_, _, _, _) in
                                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                                    })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let product = cartViewModel.getProductDetails(index: row){
            let controller = ProductDetailViewController(product: product)
            navigationController?.pushViewController(controller, animated: true)
        }
        else{
            self.present(networkErroralert, animated: true)
        }
    }
}

// MARK: - CartListViewModelDelegate
extension CartListViewController: CartListViewModelDelegate {
    func cartUpated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func cartUpdatedFailure(errorType: CartRequestError) {
        switch errorType {
        case .requestTimedOut:
            if presentedViewController == nil{
                self.present(self.networkErroralert, animated: true)
            }
        default:
            if presentedViewController == nil { // if no alert is prenseting, present the alert.
                self.present(apiErrorAlert, animated: true)
            }
        }
    }
}
