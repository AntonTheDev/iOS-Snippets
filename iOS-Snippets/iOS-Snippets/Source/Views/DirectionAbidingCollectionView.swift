//
//  DirectionAbidingCollectionView.swift
//  iOS-Snippets
//
//  Created by Anton Doudarev on 12/10/16.
//  Copyright © 2016 Anton Doudarev. All rights reserved.
//

import Foundation
import UIKit

class DirectionAbidingCollectionView : UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupDelayRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDelayRecognizer()
    }
    
    func setupDelayRecognizer() {
        addGestureRecognizer(delayPanGestureRecognizer)
        panGestureRecognizer.delaysTouchesBegan = true
    }
    
    lazy var delayPanGestureRecognizer: UIPanGestureRecognizer = {
        var recognizer = UIPanGestureRecognizer()
        recognizer.delegate = self
        return recognizer
    }()
}

extension DirectionAbidingCollectionView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer == delayPanGestureRecognizer && otherGestureRecognizer == panGestureRecognizer) {
            return true
        }
        
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == delayPanGestureRecognizer {
            
            if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
                
                let scrollDirection = flowLayout.scrollDirection
                let translation = delayPanGestureRecognizer.translation(in: self)
                
                let xTransaltionValue = (translation.x * translation.x)
                let yTransaltionValue = (translation.y * translation.y)
                
                if scrollDirection == .vertical && xTransaltionValue > yTransaltionValue {
                    return true
                }
                else if scrollDirection == .horizontal && xTransaltionValue < yTransaltionValue {
                    return true
                }
                else {
                    return false
                }
            }
        }
        
        return true
    }
}
