//
//  SearchBarViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/06/05.
//

import UIKit
import HousUIComponent
import RxSwift

final class SearchBarViewCell: UICollectionViewCell {

  private var isNew: Bool = false {
    didSet {
      if isNew {
        dotView.backgroundColor = Colors.blueL1.color
        newLabel.isHidden = false
      }
    }
  }

  private let dotView = UIView().then {
    $0.backgroundColor = Colors.g3.color
  }

  let selectButton = UIButton().then {
    $0.isUserInteractionEnabled = false
    $0.isHidden = true
    $0.setImage(Images.icDot4.image, for: .normal)
    $0.setImage(Images.icCheck2.image, for: .selected)
  }

  private let nameLabel = HousLabel(
    text: nil,
    font: .B2,
    textColor: Colors.g7.color
  ).then {
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }

  private let newLabel = HousLabel(
    text: OurRule.MainView.new,
    font: .EN2,
    textColor: Colors.blue.color
  ).then {
    $0.isHidden = true

  }

  var disposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    dotView.layer.cornerRadius = dotView.layer.frame.height / 2
    dotView.layer.masksToBounds = true
  }

  private func configUI() {
    contentView.addSubViews([
      dotView,
      selectButton,
      nameLabel,
      newLabel
    ])

    dotView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(30)
      make.size.equalTo(8)
    }

    selectButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(4)
      make.size.equalTo(44)
    }

    nameLabel.snp.makeConstraints { make in
      make.centerY.equalTo(dotView)
      make.leading.equalTo(dotView.snp.trailing).offset(18)
    }

    newLabel.snp.makeConstraints { make in
      make.centerY.equalTo(dotView)
      make.leading.equalTo(nameLabel.snp.trailing).offset(8)
      make.trailing.equalToSuperview().inset(40)
    }

  }

  func configureCell(name: String) {
    nameLabel.text = name
  }

}
