//
//  ShopItemCell.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 4/2/21.
//

import UIKit

final class ShopItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = "shop_item_cell"
    
    let itemNameLabel = UILabel()
    let itemDescLabel = UILabel()
    let itemPriceLabel = UILabel()
    let itemImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 10
        backgroundColor = .init(white: 0.5, alpha: 0.3)
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemDescLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.font = .roundedFont(ofSize: 15, weight: .medium)
        itemNameLabel.textColor = .white
        itemDescLabel.font = .roundedFont(ofSize: 15, weight: .medium)
        itemDescLabel.textColor = .white
        itemPriceLabel.font = .roundedFont(ofSize: 15, weight: .medium)
        itemPriceLabel.textColor = .white
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.backgroundColor = .white
        itemImageView.layer.masksToBounds = true
        itemImageView.layer.cornerRadius = 10
        
        contentView.addSubviews(itemImageView, itemNameLabel, itemDescLabel, itemPriceLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            itemImageView.widthAnchor.constraint(equalToConstant: 50),
            
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20),
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            itemDescLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20),
            itemDescLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            itemPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: itemNameLabel.trailingAnchor, constant: 8),
            itemPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            itemPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
