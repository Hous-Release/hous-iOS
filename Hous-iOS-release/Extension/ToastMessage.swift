//
//  UIViewController+Extension.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/06.
//
import UIKit

class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
      toastLabel.font = Fonts.SpoqaHanSansNeo.regular.font(size: 14)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let labelConstraint1 = NSLayoutConstraint(
          item: toastLabel, attribute: .leading, relatedBy: .equal,
          toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 0)
        let labelConstraint2 = NSLayoutConstraint(
          item: toastLabel, attribute: .trailing, relatedBy: .equal,
          toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let labelConstraint3 = NSLayoutConstraint(
          item: toastLabel, attribute: .bottom, relatedBy: .equal,
          toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let labelConstraint4 = NSLayoutConstraint(
          item: toastLabel, attribute: .top, relatedBy: .equal,
          toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([labelConstraint1, labelConstraint2, labelConstraint3, labelConstraint4])

        let containerConstraint1 = NSLayoutConstraint(
          item: toastContainer, attribute: .leading, relatedBy: .equal,
          toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let containerConstraint2 = NSLayoutConstraint(
          item: toastContainer, attribute: .trailing, relatedBy: .equal,
          toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let containerConstraint3 = NSLayoutConstraint(
          item: toastContainer, attribute: .bottom, relatedBy: .equal,
          toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -100)
        controller.view.addConstraints([containerConstraint1, containerConstraint2, containerConstraint3])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
