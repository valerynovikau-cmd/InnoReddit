//
//  IRDynamicBorderedView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 4.11.25.
//

import UIKit

class IRDynamicBorderedView: UIView {
    var dynamicBorderColor: UIColor? {
        didSet { updateBorderColor() }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.updateBorderColor()
        }
    }
    
    private func updateBorderColor() {
        guard let dynamicBorderColor else { return }
        layer.borderColor = dynamicBorderColor
            .resolvedColor(with: traitCollection)
            .cgColor
    }
}
