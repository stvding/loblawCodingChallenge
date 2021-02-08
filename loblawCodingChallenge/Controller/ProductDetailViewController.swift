//
//  ProductDetailViewController.swift
//  loblawCodingChallenge
//
//  Created by tommytexter on 2021-02-06.
//

import Foundation
import UIKit


class ProductDetailViewController: UIViewController {
    
    private var detailsView: ProductDetailView = ProductDetailView()
    private var productDetail: Product
    
    init(product: Product) {
        self.productDetail = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(detailsView)
        
        title = LoblawConstants.ViewContollerTitle.productDetailViewControllerTitle
        
        NSLayoutConstraint.activate([
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        detailsView.configure(with: productDetail)
    }
}
