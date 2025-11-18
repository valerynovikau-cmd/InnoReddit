//
//  IRPostCellButton.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 17.11.25.
//

import UIKit

class IRPostCellButton: UIButton {

    private let insetSize: CGFloat = 2
    private let imagePadding: CGFloat = 5
    private let imagePointSize: CGFloat = 18
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .label
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: insetSize, leading: insetSize, bottom: insetSize, trailing: insetSize)
        configuration.imagePadding = imagePadding
        self.configuration = configuration
    }
    
    func setSystemImageConfiguration(systemName: String) {
        guard let image = UIImage(systemName: systemName) else { return }
        self.configuration?.image = image
        self.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: imagePointSize, weight: .medium)
    }
    
    func setTitleConfiguration(titleText: String, fontSize: CGFloat) {
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: fontSize)
        self.configuration?.attributedTitle = AttributedString(titleText, attributes: container)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
