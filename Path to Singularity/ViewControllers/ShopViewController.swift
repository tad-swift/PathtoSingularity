//
//  ShopViewController.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 4/2/21.
//

import UIKit
import SceneKit

final class ShopViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var shopTypeView: UIView!
    var shopItemsView: UIView!
    
    var shopTypesCollectionView: UICollectionView!
    var shopItemsCollectionView: UICollectionView!
    var shopTypeDataSource: UICollectionViewDiffableDataSource<Section, ItemType>!
    var shopItemsDataSource: UICollectionViewDiffableDataSource<Section, ShopItem>!
    var currentShop: ItemType = .boostItem
    let shopTypesList: [ItemType] = [.boostItem, .star]
    var starShopItems: [ShopItem] = [
        
    ]
    
    var boostShopItems: [ShopItem] = [
        ShopItem(name: "Chlorophyll", itemType: .boostItem, price: 10, image: UIImage(named: "chlorophyll")!,
                 item: BoostItem(name: "Chloropyll", value: 1)),
        ShopItem(name: "Algae", itemType: .boostItem, price: 40, image: UIImage(named: "algae")!,
                 item: BoostItem(name: "Algae", value: 2)),
        ShopItem(name: "Tree", itemType: .boostItem, price: 200, image: UIImage(named: "tree")!,
                 item: BoostItem(name: "Tree", value: 4)),
        ShopItem(name: "Solar Panel", itemType: .boostItem, price: 1000, image: UIImage(named: "solarpanel")!,
                 item: BoostItem(name: "Solar Panel", value: 10)),
        ShopItem(name: "Field of Panels", itemType: .boostItem, price: 50_000, image: UIImage(named: "fieldofpanels")!,
                 item: BoostItem(name: "Field of Panels", value: 200)),
        ShopItem(name: "Forest", itemType: .boostItem, price: 250_000, image: UIImage(named: "forest")!,
                 item: BoostItem(name: "Forest", value: 4_000))
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 10
        configureHierarchy()
        configureDataSource()
        configureShop()
    }
    
    func configureShop() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shopTypesList, toSection: .main)
        shopTypeDataSource.apply(snapshot, animatingDifferences: true)
        switch currentShop {
            case .boostItem:
                var snapshot = NSDiffableDataSourceSnapshot<Section, ShopItem>()
                snapshot.appendSections([.main])
                if snapshot.numberOfItems > 0 {
                    snapshot.deleteAllItems()
                    shopItemsDataSource.apply(snapshot, animatingDifferences: false)
                }
                snapshot.appendItems(boostShopItems, toSection: .main)
                shopItemsDataSource.apply(snapshot, animatingDifferences: false)
            case .star:
                var snapshot = NSDiffableDataSourceSnapshot<Section, ShopItem>()
                snapshot.appendSections([.main])
                if snapshot.numberOfItems > 0 {
                    snapshot.deleteAllItems()
                    shopItemsDataSource.apply(snapshot, animatingDifferences: false)
                }
                snapshot.appendItems(starShopItems, toSection: .main)
                shopItemsDataSource.apply(snapshot, animatingDifferences: false)
        }
        
    }
    
}

// MARK: - CollectionView DataSource
extension ShopViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == shopTypesCollectionView {
            let item = shopTypeDataSource.itemIdentifier(for: indexPath)!
            currentShop = item
            configureShop()
        } else {
            let item = shopItemsDataSource.itemIdentifier(for: indexPath)!
//            if viewModel.myPlayer.energy - item.price >= 0 {
//                viewModel.myPlayer.energy -= item.price
//                NotificationCenter.default.post(name: NSNotification.Name("updateLabels"), object: nil)
//                switch item.itemType {
//                    case .boostItem:
//                        boostShopItems[indexPath.row].price += (item.price / 8)
//                        let boostItem = item.item as! BoostItem
//                    viewModel.myPlayer.boostValue += boostItem.value
//                    UserDefaults.standard.set(viewModel.myPlayer.boostValue, forKey: "BoostValue")
//                    case .star:
//                        starShopItems[indexPath.row].price += (item.price / 20)
//                        let star = item.item as! Star
//                        myStar.node.removeFromParentNode()
//                        myStar = star
//                        myStar.creatNode()
//                        NotificationCenter.default.post(name: NSNotification.Name("reloadStar"), object: nil)
//                }
//            }
            configureShop()
        }
    }
    
    func configureDataSource() {
        shopTypesCollectionView.register(ShopTypeCell.self, forCellWithReuseIdentifier: ShopTypeCell.reuseIdentifier)
        shopItemsCollectionView.register(ShopItemCell.self, forCellWithReuseIdentifier: ShopItemCell.reuseIdentifier)
        let shopTypeImages = [UIImage(named: "energyshop")!, UIImage(named: "starshop")!]
        shopTypeDataSource = UICollectionViewDiffableDataSource<Section, ItemType>(collectionView: shopTypesCollectionView, cellProvider: { (collectionView, indexPath, type) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopTypeCell.reuseIdentifier, for: indexPath) as! ShopTypeCell
            cell.imageView.image = shopTypeImages[indexPath.row]
            return cell
        })
        
        shopItemsDataSource = UICollectionViewDiffableDataSource<Section, ShopItem>(collectionView: shopItemsCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemCell.reuseIdentifier, for: indexPath) as! ShopItemCell
            cell.itemImageView.image = item.image
            cell.itemNameLabel.text = item.name
            switch item.itemType {
                case .boostItem:
                    let boostItem = item.item as! BoostItem
                    cell.itemDescLabel.text = "+\(boostItem.value.abbreviated) ✨ boost"
                case .star:
                    let starItem = item.item as! Star
                    if starItem.zams > 25 {
                        cell.itemDescLabel.text = "Mass: \(starItem.zams)  50% chance of black hole"
                    } else {
                        cell.itemDescLabel.text = "Mass: \(starItem.zams)"
                    }
                    
            }
            cell.itemPriceLabel.text = "✨\(item.price.abbreviated)"
            return cell
        })
        
    }
    
    
}

// MARK: - CollectionView Layout
extension ShopViewController: UICollectionViewDelegate {
    func createShopTypesLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                                   heightDimension: .estimated(40))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.interItemSpacing = .fixed(0)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = CGFloat(10)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        })
        return layout
    }
    
    func createShopItemsLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.interItemSpacing = .fixed(0)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = CGFloat(10)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.orthogonalScrollingBehavior = .none
            return section
        })
        return layout
    }
    
    func configureHierarchy() {
        shopTypesCollectionView = UICollectionView(frame: shopTypeView.bounds, collectionViewLayout: createShopTypesLayout())
        shopTypesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shopTypesCollectionView.backgroundColor = .clear
        shopTypesCollectionView.showsVerticalScrollIndicator = false
        shopTypesCollectionView.showsHorizontalScrollIndicator = false
        shopTypesCollectionView.isScrollEnabled = false
        shopTypeView.addSubview(shopTypesCollectionView)
        shopTypesCollectionView.delegate = self
        
        shopItemsCollectionView = UICollectionView(frame: shopItemsView.bounds, collectionViewLayout: createShopItemsLayout())
        shopItemsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shopItemsCollectionView.backgroundColor = .clear
        shopItemsCollectionView.showsVerticalScrollIndicator = false
        shopItemsView.addSubview(shopItemsCollectionView)
        shopItemsCollectionView.delegate = self
    }
}

