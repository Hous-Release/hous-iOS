//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import Foundation
import UIKit
import AssetKit

internal final class EnterPopUpView: UIView {

  private typealias SpoqaHanSansNeo = Fonts.SpoqaHanSansNeo

  private enum Constant {
    static let verticalMargin: CGFloat = 32
    static let horizontalMargin: CGFloat = 28
    static let subtitleTopMargin: CGFloat = 6
    static let buttonTopMargin: CGFloat = 20
    static let buttonHorizontalMargin: CGFloat = 18
    static let buttonHeight: CGFloat = 40
  }

  private let rootView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8
    view.backgroundColor = .white
    return view
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = Colors.black.color
    label.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.lineBreakStrategy = .hangulWordPriority
    label.textAlignment = .center
    label.textColor = Colors.g5.color
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    return label
  }()

  internal lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 8
    button.setTitle("cancelButton", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.backgroundColor = Colors.g2.color
    button.setTitleColor(Colors.g6.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    return button
  }()

  internal lazy var actionButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 8
    button.setTitle("actionButton", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.backgroundColor = Colors.red.color
    button.setTitleColor(Colors.white.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    return button
  }()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.backgroundColor = .white
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.spacing = 12
    return stackView
  }()

  internal init(_ model: DefaultPopUpModel) {
    super.init(frame: .zero)
    setupViews()
    configure(model)
  }

  required init?(coder: NSCoder) {
    fatalError("TwoButtonPopUpView is not implemented")
  }
}

extension DefaultPopUpView {

  private func configure(_ model: DefaultPopUpModel) {
    cancelButton.setTitle(model.cancelText, for: .normal)
    actionButton.setTitle(model.actionText, for: .normal)
    titleLabel.text = model.title
    subtitleLabel.text = model.subtitle
  }

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
      make.bottom.equalToSuperview().inset(Constant.verticalMargin / 2)

    }

    [cancelButton, actionButton].forEach { button in
      button.snp.makeConstraints { make in
        make.height.equalTo(Constant.buttonHeight)
      }
    }
  }
}
