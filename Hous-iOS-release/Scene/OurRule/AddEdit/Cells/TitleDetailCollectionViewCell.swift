//
//  TitleDetailCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/21.
//

import UIKit
import RxSwift
import HousUIComponent

final class TitleDetailCollectionViewCell: UICollectionViewCell {

  private let titleLabel = HousLabel(
    text: StringLiterals.OurRule.AddEditView.titleText,
    font: .B2,
    textColor: Colors.black.color).then {
      $0.applyColor(to: "*", with: .red)
    }

  let textField = FilledHousTextField(maxCount: 20)

  private let descriptionLabel = HousLabel(
    text: StringLiterals.OurRule.AddEditView.description,
    font: .B2,
    textColor: Colors.black.color
  )

  let textView = HousTextView(maxCount: 50)

  var disposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setLayout() {
    [titleLabel, textField, descriptionLabel, textView].forEach {
      contentView.addSubview($0)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(13)
      make.leading.equalToSuperview().inset(27)
    }

    textField.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.leading.equalTo(titleLabel)
      make.trailing.equalToSuperview().inset(24)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom).offset(21)
      make.leading.equalTo(titleLabel)
    }

    textView.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(4)
      make.leading.trailing.equalTo(textField)
      make.bottom.equalToSuperview().inset(25)
    }
  }

}
