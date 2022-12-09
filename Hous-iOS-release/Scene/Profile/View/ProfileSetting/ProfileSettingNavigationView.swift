//
//  ProfileSettingNavigationView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSettingNavigationBarView: UIView {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  let navigationBackButton = UIButton().then {
    $0.setImage(Images.icBack.image, for: .normal)
  }
  
  private let titleName = UILabel().then {
    $0.text = "설정"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 17)
    $0.textAlignment = .center
  }
  
  private let grayLineView = UIView().then {
    $0.backgroundColor = Colors.g2.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    self.backgroundColor = .white
  }
  
  private func render() {
    self.addSubViews([navigationBackButton, titleName, grayLineView])
    
    navigationBackButton.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(24)
//      make.width.height.equalTo(24)
    }
    
    titleName.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalTo(navigationBackButton.snp.centerY).offset(2)
    }
    
    grayLineView.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.height.equalTo(1)
      make.leading.trailing.equalToSuperview()
    }
  }
}
