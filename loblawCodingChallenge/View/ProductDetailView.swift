//
//  ProductDetailView.swift
//  loblawCodingChallenge
//
//  Created by tommytexter on 2021-02-06.
//

import Foundation
import UIKit

class ProductDetailView: UIView {
    private let boldAttri = [NSAttributedString.Key.font: UIFont(name: LoblawConstants.Text.productDetailViewTextFontBold,
                                                                 size: LoblawConstants.Text.productDetailViewTextSize)!]
    private let regAttri = [NSAttributedString.Key.font: UIFont(name: LoblawConstants.Text.productDetailViewTextFontReg,
                                                                size: LoblawConstants.Text.productDetailViewTextSize)!]
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: LoblawConstants.Text.productDetailViewTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: LoblawConstants.Text.productDetailViewTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: LoblawConstants.Text.productDetailViewTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = LoblawConstants.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        
        addSubview(productImage)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: LoblawConstants.DetailViewLayoutReference.productImageTopSpacing),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LoblawConstants.DetailViewLayoutReference.productImageSideMargin),
            productImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LoblawConstants.DetailViewLayoutReference.productImageSideMargin),
            productImage.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: LoblawConstants.DetailViewLayoutReference.productImageMaxHeightInPrecentageOfScreen),
            
            nameLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: LoblawConstants.DetailViewLayoutReference.labelVerticalSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LoblawConstants.DetailViewLayoutReference.labelSideMargin),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LoblawConstants.DetailViewLayoutReference.labelSideMargin),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: LoblawConstants.DetailViewLayoutReference.labelVerticalSpacing),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LoblawConstants.DetailViewLayoutReference.labelSideMargin),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LoblawConstants.DetailViewLayoutReference.labelSideMargin),
            
            typeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: LoblawConstants.DetailViewLayoutReference.labelVerticalSpacing),
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LoblawConstants.DetailViewLayoutReference.labelSideMargin),
            typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LoblawConstants.DetailViewLayoutReference.labelSideMargin),
        ])
    }
    
    func configure(with product: Product) {
        let name = NSMutableAttributedString(string: "Product\n",attributes: boldAttri)
        let price = NSMutableAttributedString(string: "Price\n",attributes: boldAttri)
        let type = NSMutableAttributedString(string: "Type\n",attributes: boldAttri)
        
        name.append(NSAttributedString(string: product.name, attributes: regAttri))
        price.append(NSAttributedString(string: product.price, attributes: regAttri))
        type.append(NSAttributedString(string: product.type, attributes: regAttri))
        
        
        nameLabel.attributedText = name
        priceLabel.attributedText = price
        typeLabel.attributedText = type
        
        productImage.sd_setImage(with: URL(string: product.image),
                                 placeholderImage: UIImage(named: LoblawConstants.ImageService.placeHolderImageName),
                                 options: [.continueInBackground],
                                 completed: { [weak self] (_, _, _, _) in
                                    DispatchQueue.main.async {
                                        self?.productImage.setNeedsLayout()
                                    }}
        )
    }
}
