//
//  ProfileDetailNavigationView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailNavigationBarView: UIView {
  
  private let disposeBag: DisposeBag = DisposeBag()
  let viewActionControlSubject = PublishSubject<ProfileDetailActionControl>()
  
  private let navigationBackButton = UIButton().then {
    $0.setImage(Images.icBack.image, for: .normal)
  }
  
  private let titleName = UILabel().then {
    $0.text = "성향 설명"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 17)
    $0.textAlignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
    transferToViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    self.backgroundColor = .white
  }
  
  private func render() {
    self.addSubViews([navigationBackButton, titleName])
    
    navigationBackButton.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(24)
//      make.width.height.equalTo(24)
    }
    
    titleName.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalTo(navigationBackButton.snp.centerY).offset(2)
    }
  }
  
  private func transferToViewController() {
    self.navigationBackButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewActionControlSubject.onNext(.didTabBack)
      }
      .disposed(by: disposeBag)
  }
}



