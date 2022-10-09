//
//  File.swift
//  
//
//  Created by 김호세 on 2022/10/10.
//

import Foundation
import UIKit

internal final class TwoButtonPopUpView: UIView {


  private enum Constant {
    static let verticalMargin: CGFloat = 32
    static let horizontalMargin: CGFloat = 28
    static let subtitleTopMargin: CGFloat = 8
    static let buttonTopMargin: CGFloat = 20
    static let buttonHorizontalMargin: CGFloat = 18
  }

  private let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 8
    return view
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .black
    label.font = .systemFont(ofSize: 18, weight: .bold)

//    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
//    $0.dynamicFont(fontSize: 18, weight: .bold)
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.lineBreakStrategy = .hangulWordPriority
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 12, weight: .medium)
//    $0.textColor = Colors.g5.color
//    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
//    $0.dynamicFont(fontSize: 12, weight: .medium)
    return label
  }()

  // MARK: - No Action - Just Dismiss
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 8
    button.setTitle("cancelButton", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    return button
  }()

  private lazy var actionButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 8
    button.setTitle("actionButton", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    return button
  }()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 12
    return stackView
  }()

  internal init() {
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("TwoButtonPopUpView is not implemented")
  }


}

extension TwoButtonPopUpView {
  private func setupViews() {
    addSubview(rootView)
    rootView.addSubview(titleLabel)
    rootView.addSubview(subtitleLabel)
    rootView.addSubview(buttonStackView)

    buttonStackView.addArrangedSubview(cancelButton)
    buttonStackView.addArrangedSubview(actionButton)

    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .inset(Constant.verticalMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.horizontalMargin)
    }

    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(Constant.subtitleTopMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.horizontalMargin + 8)
    }

    buttonStackView.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(Constant.buttonTopMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.buttonHorizontalMargin)
    }
  }
}
