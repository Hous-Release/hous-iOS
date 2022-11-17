//
//  IndividualCell.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/13.
//

import AssetKit
import UIKit

final class IndividualCell: UICollectionViewCell {
  private struct Constants {
    static let colorViewSize: CGSize = CGSize(width: 16, height: 16)
    static let verticalMargin: CGFloat = 14
    static let horizontalMargin: CGFloat = 28
    static let distance: CGFloat = 12
  }

  private let containerView: UIView = {
    let view = UIView()
    view.layer.cornerCurve = .continuous
    return view
  }()

  private let colorButton: UIButton = {
    let button = UIButton()
    button.isUserInteractionEnabled = false
    return button
  }()

  private let homieNamelabel: UILabel = {
    let label = UILabel()
    label.text = "homieNamelabel"
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    label.textAlignment = .left
    label.textColor = Colors.black.color
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemnted")
  }

  func configure(_ model: UpdateTodoHomieModel) {
    let factory = HomieFactory.makeHomie(type: model.color)

    homieNamelabel.text = model.name
    colorButton.setImage(factory.todoUpdateMemberSelectedImage, for: .selected)
    colorButton.setImage(factory.todoUpdateMemberUnSelectedImage, for: .normal)

  }


  private func setupViews() {
    contentView.backgroundColor = Colors.white.color
    contentView.addSubview(containerView)

    containerView.addSubview(colorButton)
    containerView.addSubview(homieNamelabel)

    containerView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(Constants.verticalMargin)
      make.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
    }
    colorButton.snp.makeConstraints { make in
      make.size.equalTo(Constants.colorViewSize)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
    }
    homieNamelabel.snp.makeConstraints { make in
      make.leading.equalTo(colorButton.snp.trailing).offset(Constants.distance)
      make.top.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }

}
