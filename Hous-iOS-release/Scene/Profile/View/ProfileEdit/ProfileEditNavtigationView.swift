//
//  ProfileEditNavtigationView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditNavigationBarView: UIView {

  private let disposeBag: DisposeBag = DisposeBag()

  let navigationBackButton = ProfileEditBackButton()

  let saveButton = UIButton().then {
    $0.setTitle("저장", for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.setTitleColor(Colors.g4.color, for: .disabled)
    $0.setTitleColor(Colors.blue.color, for: .normal)
    $0.isEnabled = false
  }

  private let titleName = UILabel().then {
    $0.text = "프로필 수정"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 17)
    $0.textAlignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.backgroundColor = .white
  }

  private func render() {
    self.addSubViews([navigationBackButton, titleName, saveButton])

    navigationBackButton.snp.makeConstraints {make in
      make.size.equalTo(24)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(24)
    }

    titleName.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalTo(navigationBackButton.snp.centerY).offset(2)
    }

    saveButton.snp.makeConstraints { make in
      make.size.greaterThanOrEqualTo(24)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(24)
    }
  }
}
