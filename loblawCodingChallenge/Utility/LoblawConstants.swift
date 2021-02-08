//
//  LoblawConstants.swift
//  loblawCodingChallenge
//
//  Created by tommytexter on 2021-02-06.
//

import Foundation
import UIKit

struct LoblawConstants {
    struct ImageService {
        static let placeHolderImageName = "defaultProductImage"
    }
    
    struct Text {
        static let productDetailViewTextSize: CGFloat = 20
        static let productDetailViewTextFontReg: String = "AvenirNextCondensed-Regular"
        static let productDetailViewTextFontBold: String = "AvenirNextCondensed-Bold"
        static let cartListViewTextSize: CGFloat = 20
        static let cartListViewTextFont: String = "AvenirNextCondensed-DemiBold"
    }
    
    struct AlertErrorMsg {
        static let errorTitle: String = "Houston, we have a problem!"
        static let serverError: String = "Internal error occured, please wait while we are fixing the issue."
        static let networkError: String = "No data available."
        static let retry: String = "Retry"
        static let cancel: String = "Cancel"
        static let exit: String = "Exit"
    }
    
    static let cornerRadius: CGFloat = 20
    
    struct ViewContollerTitle {
        static let cartListViewControllerTitle: String = "Product List"
        static let productDetailViewControllerTitle: String = "Product Information"
    }

    struct DetailViewLayoutReference {
        static let labelSideMargin: CGFloat = 20
        static let labelVerticalSpacing: CGFloat = 20
        static let productImageTopSpacing: CGFloat = 150
        static let productImageSideMargin: CGFloat = 20
        static let productImageMaxHeightInPrecentageOfScreen: CGFloat = 0.7
    }
    
}
