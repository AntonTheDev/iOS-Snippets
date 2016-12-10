//
//  ColumnBasedVerticalLayout.swift
//  iOS-Snippets
//
//  Created by Anton Doudarev on 12/10/16.
//  Copyright © 2016 Anton Doudarev. All rights reserved.
//

import Foundation
import UIKit
protocol ColumnBasedVerticalLayoutDelegate : class {
    func flowLayout(_ flowLayout : ColumnBasedVerticalLayout, sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    func numberOfcolumns(in flowLayout : ColumnBasedVerticalLayout) -> Int
}

class ColumnBasedVerticalLayout: UICollectionViewFlowLayout {
    
    weak var delegate : ColumnBasedVerticalLayoutDelegate?
    
    fileprivate var attributeCache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight:CGFloat  = 0.0
    
    override init() {
        super.init()
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
        sectionInset = UIEdgeInsets.zero
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        
        guard let delegate = delegate else {
            return
        }
        
        let numberOfColumns = delegate.numberOfcolumns(in: self)
        let columnWidth = collectionView!.bounds.width / CGFloat(numberOfColumns)
        
        var xOffset = [CGFloat]()
        
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let size = delegate.flowLayout(self, sizeForItemAtIndexPath: (indexPath as NSIndexPath) as IndexPath)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: xOffset[column], y: yOffset[column], width: size.width, height: size.height)
            attributeCache.append(attributes)
            
            contentHeight = max(contentHeight, attributes.frame.maxY)
            yOffset[column] = yOffset[column] + CGFloat(size.height)
            
            if column >= (numberOfColumns - 1) {
                column = 0
            } else {
                column = column + 1
            }
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in attributeCache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
