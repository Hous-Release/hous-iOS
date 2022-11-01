//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import Foundation
import UIKit
import AssetKit

internal final class CopyCodePopUpView: UIView {

  private typealias SpoqaHanSansNeo = Fonts.SpoqaHanSansNeo

  private enum Constant {
    static let imageTopMargin: CGFloat = 52
    static let cancelButtonSize: CGFloat = 24
    static let verticalMargin: CGFloat = 20
    static let imageHorizontalMargin: CGFloat = 62
    static let horizontalMargin: CGFloat = 20
    static let itemTopMargin: CGFloat = 16
    static let buttonHeight: CGFloat = 42
  }

  private let rootView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8
    view.backgroundColor = .white
    return view
  }()

  internal lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(Images.icClose.image, for: .normal)
    return button
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    return imageView
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.lineBreakStrategy = .hangulWordPriority
    label.textAlignment = .center
    label.textColor = Colors.g5.color
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    return label
  }()


  internal lazy var actionButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 8
    button.setTitle("actionButton", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.backgroundColor = Colors.g1.color
    button.setTitleColor(Colors.g7.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    return button
  }()


  internal init(_ model: ImagePopUpModel) {
    super.init(frame: .zero)
    setupViews()
    configure(model)
  }

  required init?(coder: NSCoder) {
    fatalError("CopyCodePopUpView is not implemented")
  }
}

extension CopyCodePopUpView {

  private func configure(_ model: ImagePopUpModel) {

    actionButton.setTitle(model.actionText, for: .normal)
    subtitleLabel.text = model.text

    // TODO: - Image
//    imageView.image =
  }

  private func setupViews() {
    addSubview(rootView)

    rootView.addSubview(cancelButton)
    rootView.addSubview(imageView)
    rootView.addSubview(subtitleLabel)
    rootView.addSubview(actionButton)


    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    cancelButton.snp.makeConstraints { make in
      make.width.height.equalTo(Constant.cancelButtonSize)
      make.top.equalToSuperview().inset(Constant.verticalMargin)
      make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
    }

    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .inset(Constant.imageTopMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.imageHorizontalMargin).priority(.high)
      make.height.equalTo(imageView.snp.width)
    }

    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(Constant.itemTopMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.horizontalMargin)
    }

    actionButton.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(Constant.itemTopMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.horizontalMargin)
      make.height.equalTo(Constant.buttonHeight)

    }
  }
}
