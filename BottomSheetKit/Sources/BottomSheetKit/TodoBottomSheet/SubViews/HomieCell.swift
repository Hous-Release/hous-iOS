//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/11.
//

import AssetKit
import SnapKit
import UIKit


final internal class HomieCell: UICollectionViewCell {

  private struct Constants {
    static let colorViewSize: CGSize = CGSize(width: 12, height: 12)
    static let verticalMargin: CGFloat = 4
    static let horizontalMargin: CGFloat = 6
    static let distance: CGFloat = 4
  }

  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.g1.color
    view.layer.cornerCurve = .continuous
    view.layer.cornerRadius = 6
    return view
  }()

  private let colorLabel: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 6
    view.layer.cornerCurve = .circular
    return view
  }()

  private let homieNamelabel: UILabel = {
    let label = UILabel()
    label.text = "homieNamelabel"
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    label.textAlignment = .center
    label.textColor = Colors.g6.color
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemnted")
  }

  func setupViews() {
    contentView.backgroundColor = Colors.white.color
    contentView.addSubview(containerView)
    containerView.addSubview(colorLabel)
    containerView.addSubview(homieNamelabel)

    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    colorLabel.snp.makeConstraints { make in
      make.size.equalTo(Constants.colorViewSize)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(Constants.horizontalMargin)
    }
    homieNamelabel.snp.makeConstraints { make in
      make.leading.equalTo(colorLabel.snp.trailing).offset(Constants.distance)
      make.top.bottom.equalToSuperview().inset(Constants.verticalMargin)
      make.trailing.equalToSuperview().inset(Constants.horizontalMargin)
    }

  }

  func configure(_ model: HomieCellModel) {

    colorLabel.backgroundColor = model.homieColor
    homieNamelabel.text = model.homieName
  }

}
