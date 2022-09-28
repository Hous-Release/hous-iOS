//
//  OurTodoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/11.
//

import UIKit

enum OurTodoStatus: String {
  case empty = "EMPTY"
  case full = "FULL"
  case fullCheck = "FULLCHECK"
}

final class OurTodoCollectionViewCell: UICollectionViewCell {

  var status: OurTodoStatus = .empty {
    didSet {
      switch status {
      case .empty:
        iconImageView.image = Images.icNoOur.image
      case .full:
        iconImageView.image = Images.icHalfDoneOur.image
      case .fullCheck:
        iconImageView.image = Images.icDoneOur.image
      }
    }
  }

  private var iconImageView = UIImageView().then {
    $0.image = Images.icDoneOur.image
  }

  var ourTodoLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
    $0.text = "블라블라블라"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension OurTodoCollectionViewCell {

  private func render() {

    [iconImageView, ourTodoLabel].forEach { addSubview($0) }

    iconImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(26)
      make.centerY.equalToSuperview()
      make.size.equalTo(20)
    }

    ourTodoLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImageView.snp.trailing).offset(12)
      make.centerY.equalToSuperview()
      make.width.greaterThanOrEqualTo(200)
    }
  }

  func setCell(_ status: String, _ todoName: String) {
    self.status = OurTodoStatus(rawValue: status) ?? .empty
    ourTodoLabel.text = todoName
  }
}
