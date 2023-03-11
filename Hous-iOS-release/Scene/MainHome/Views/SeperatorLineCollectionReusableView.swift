//
//  SeperatorLineCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/11.
//

import UIKit

class SeperatorLineCollectionReusableView: UICollectionReusableView {

  private let seperatorLineView = UIView().then {
    $0.backgroundColor = Colors.g2.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI() {
    addSubview(seperatorLineView)
    seperatorLineView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(1)
    }
  }
}
