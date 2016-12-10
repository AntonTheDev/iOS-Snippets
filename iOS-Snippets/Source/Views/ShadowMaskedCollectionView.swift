//
//  ShadowMaskedCollectionView.swift
//  iOS-Snippets
//
//  Created by Anton Doudarev on 12/10/16.
//  Copyright © 2016 Anton Doudarev. All rights reserved.
//

import Foundation
import UIKit

class ShadowMaskedCollectionView: UICollectionView {
    
    override var contentOffset: CGPoint {
        didSet {
            configureLayerMaskIfNeeded()
            updateLayerMask()
        }
    }
    
    private func updateLayerMask() {
        
        if layer.mask != nil  || bounds.height != 0.0 {
            let innerColor: CGColor =  UIColor(hex: "#00000033").cgColor
            let outerColor: CGColor =  UIColor(hex: "#000000").cgColor
            var colors: [AnyObject]
            
            colors = [innerColor, innerColor, innerColor, outerColor]
            if let _ = layer.mask as? CAGradientLayer {
                ((layer.mask as! CAGradientLayer)).colors = colors
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.mask!.position = CGPoint(x: 0, y: contentOffset.y - 5.0)
                
                CATransaction.commit()
            }
        }
    }
    
    // Solution Found Here : http://stackoverflow.com/questions/10570247/fade-edges-of-uitableview
    private func configureLayerMaskIfNeeded () {
        if layer.mask == nil  || bounds.height != 0.0 {
            maskLayer.bounds = CGRect(x:0, y: 0, width:frame.size.width, height:frame.size.height);
            maskLayer.anchorPoint = CGPoint.zero
            layer.mask = maskLayer;
            updateLayerMask()
        }
        
        maskLayer.locations = [0, 0.0015, 0.0025, 0.020]
    }
    
    lazy var maskLayer: CAGradientLayer = {
        let maskLayer = CAGradientLayer()
        maskLayer.anchorPoint = CGPoint.zero
        return maskLayer
    }()
}
