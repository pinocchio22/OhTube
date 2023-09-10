//
//  UIViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/10.
//

import UIKit

// LoginViewController, RegistratinController
extension UIViewController {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func showKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= 85
        }
    }

    @objc private func hideKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y += 85
        }
    }
}

// DetailViewController
extension UIViewController {
    func setDetailKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDetailKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideDetailKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func showDetailKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }

    @objc private func hideDetailKeyboard(_ notification: Notification) {
        self.view.transform = .identity
    }
}
