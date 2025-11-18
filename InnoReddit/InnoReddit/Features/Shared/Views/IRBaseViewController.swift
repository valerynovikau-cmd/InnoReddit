//
//  IRBaseViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 18.11.25.
//

import UIKit

class IRBaseViewController: UIViewController {
    func presentAlertController(title: String?, message: String?, buttonTitle: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        self.present(alert, animated: true)
    }
}
