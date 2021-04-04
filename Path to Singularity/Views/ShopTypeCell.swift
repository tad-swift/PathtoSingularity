//
//  ShopTypeCell.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 4/2/21.
//

import UIKit

final class ShopTypeCell: UICollectionViewCell {
    
    static let reuseIdentifier = "shop_type_cell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
    
}
