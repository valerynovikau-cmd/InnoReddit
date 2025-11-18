//
//  IRPostCellButton.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 17.11.25.
//

import UIKit

class IRPostCellButton: UIButton {
    private let insetSize: CGFloat
    private let imagePadding: CGFloat
    private let imagePointSize: CGFloat
    
    init(
        size: CGFloat,
        insetSize: CGFloat = 2,
        imagePadding: CGFloat = 5,
        imagePointSize: CGFloat = 18,
        tintColor: UIColor = .label
    ) {
        self.insetSize = insetSize
        self.imagePadding = imagePadding
        self.imagePointSize = imagePointSize
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = tintColor
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: insetSize,
            leading: insetSize,
            bottom: insetSize,
            trailing: insetSize
        )
        configuration.imagePadding = imagePadding
        self.configuration = configuration
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: size),
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: size)
        ])
    }
    
    func setSystemImageConfiguration(systemName: String) {
        guard let image = UIImage(systemName: systemName) else { return }
        self.configuration?.image = image
        self.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: imagePointSize, weight: .medium)
    }
    
    func setTitleConfiguration(titleText: String, fontSize: CGFloat) {
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        self.configuration?.attributedTitle = AttributedString(titleText, attributes: container)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
