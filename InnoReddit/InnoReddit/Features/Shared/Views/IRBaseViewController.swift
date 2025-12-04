//
//  IRBaseViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 18.11.25.
//

import UIKit

class IRBaseViewController: UIViewController {
    func presentAlertController(title: String?, message: String?, buttonTitle: String? = "OK") {
        let alert = UIAlertController(title: title ?? "Error", message: message ?? "An unknown error occured", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle ?? "OK", style: .default))
        self.present(alert, animated: true)
    }
}
