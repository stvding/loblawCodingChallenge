//
//  CartListViewModel.swift
//  loblawCodingChallenge
//
//  Created by tommytexter on 2021-02-06.
//

import Foundation

protocol CartListViewModelDelegate: AnyObject {
    // do someting after cart updated
    func cartUpated()
    // handle cart update failure
    func cartUpdatedFailure(errorType: CartRequestError)
}


protocol CartListViewModelInterface {
    // Request for cart info
    func requestCartInfo()
    
    // Retrieve prodcut count
    func getProductCount() -> Int
    
    // Retrieve full prodcut info
    func getProductDetails(index: Int) -> Product?
    
    // Retrieve prodcut name
    func getProductName(index: Int) -> String
    
    // Retrieve prodcut image URL
    func getProductImageURL(index: Int) -> String
    
    // CartListViewModelDelegate
    var delegate: CartListViewModelDelegate? { get set }
}


class CartListViewModel: CartListViewModelInterface {
    private let apiClient: LoblawApiClientInterface
    
    weak var delegate: CartListViewModelDelegate?
    
    private var cart: [Product] = []
    
    init(apiClient: LoblawApiClientInterface) {
        self.apiClient = apiClient
    }
    
    // MARK: - CartListViewModelInterface
    func requestCartInfo() {
        if !Reachability.isConnectedToNetwork {
            // No network, report failure
            self.delegate?.cartUpdatedFailure(errorType: .requestTimedOut)
            return
        }
        
        apiClient.requestCartInfo { [weak self] response in
            self?.cart = response.entries
            self?.delegate?.cartUpated()
        } onFailure: { [weak self] error in
            self?.delegate?.cartUpdatedFailure(errorType: error)
        }
    }
    
    func getProductCount() -> Int {
        return cart.count
    }
    
    func getProductDetails(index: Int) -> Product? {
        if index >= cart.count {
            self.delegate?.cartUpdatedFailure(errorType: .apiError)
            return nil
        }
        
        let product = cart[index]
        
        return Product(code: product.code,
                       name: product.name,
                       image: product.image,
                       price: product.price,
                       type: product.type
        )
    }
    
    func getProductName(index: Int) -> String {
        if index >= cart.count {
            self.delegate?.cartUpdatedFailure(errorType: .apiError)
            return ""
        }
        
        let product = cart[index]
        return product.name
    }
    
    func getProductImageURL(index: Int) -> String {
        if index >= cart.count {
            self.delegate?.cartUpdatedFailure(errorType: .apiError)
            return ""
        }
        
        let product = cart[index]
        return product.image
    }

}
