//
//  StickyHeaderCollectionViewLayout.swift
//  iOS-Snippets
//
//  Created by Anton Doudarev on 12/10/16.
//  Copyright © 2016 Anton Doudarev. All rights reserved.
//

import Foundation
import UIKit

class StickyHeaderCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
        sectionInset = UIEdgeInsets.zero
        scrollDirection = .vertical
    }
    
    var finalAttributes = [UICollectionViewLayoutAttributes]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attributes?.alpha = 1.0
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let superAttributes:NSMutableArray = NSMutableArray(array: super.layoutAttributesForElements(in: rect)!) as NSMutableArray
        
        let contentOffset = collectionView!.contentOffset
        let missingSections = NSMutableIndexSet()
        
        for layoutAttributes in superAttributes {
            if ((layoutAttributes as AnyObject).representedElementCategory == .cell) && (layoutAttributes as AnyObject).indexPath != nil  {
                missingSections.add((layoutAttributes as AnyObject).indexPath!.section)
            }
        }
        
        for layoutAttributes in superAttributes {
            if (layoutAttributes as AnyObject).representedElementKind == UICollectionElementKindSectionHeader {
                if let indexPath = (layoutAttributes as AnyObject).indexPath {
                    missingSections.remove(indexPath.section)
                }
            }
        }
        
        missingSections.enumerate(using: { idx, stop in
            let indexPath = IndexPath(item: 0, section: idx)
            let layoutAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
            superAttributes.add(layoutAttributes!)
        })
        
        for la in superAttributes {
            
            let layoutAttributes = la as! UICollectionViewLayoutAttributes;
            
            if let representedElementKind = layoutAttributes.representedElementKind {
                if representedElementKind == UICollectionElementKindSectionHeader {
                    let section = layoutAttributes.indexPath.section
                    let numberOfItemsInSection = collectionView!.numberOfItems(inSection: section)
                    
                    let firstCellIndexPath = IndexPath(item: 0, section: section)
                    let lastCellIndexPath = IndexPath(item: max(0, (numberOfItemsInSection - 1)), section: section)
                    
                    var firstCellAttributes:UICollectionViewLayoutAttributes
                    var lastCellAttributes:UICollectionViewLayoutAttributes
                    
                    if (self.collectionView!.numberOfItems(inSection: section) > 0) {
                        firstCellAttributes = self.layoutAttributesForItem(at: firstCellIndexPath)!
                        lastCellAttributes = self.layoutAttributesForItem(at: lastCellIndexPath)!
                    } else {
                        firstCellAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: firstCellIndexPath)!
                        if let  lastAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: lastCellIndexPath) {
                            lastCellAttributes = lastAttributes
                        } else {
                            lastCellAttributes = firstCellAttributes
                        }
                    }
                    
                    let headerHeight = layoutAttributes.frame.height
                    var origin = layoutAttributes.frame.origin
                    
                    origin.y = min(max(contentOffset.y, (firstCellAttributes.frame.minY - headerHeight)), (lastCellAttributes.frame.maxY - headerHeight))
                    ;
                    
                    layoutAttributes.zIndex = 1024;
                    layoutAttributes.frame = CGRect(origin: origin, size: layoutAttributes.frame.size)
                }
            }
        }
        
        return NSArray(array: superAttributes) as? [UICollectionViewLayoutAttributes]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
