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
  let viewActionControlSubject = PublishSubject<ProfileEditActionControl>()
  
  private let navigationBackButton = UIButton().then {
    let image = Images.icBack.image
    let newWidth = 28
    let newHeight = 28
    let newImageRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: newImageRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    UIGraphicsEndImageContext()
    $0.setImage(newImage, for: .normal)
  }
  
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
    transferToViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    self.backgroundColor = .white
  }
  
  private func render() {
    self.addSubViews([navigationBackButton, titleName, saveButton])
    
    navigationBackButton.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(24)
//      make.width.height.equalTo(24)
    }
    
    titleName.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalTo(navigationBackButton.snp.centerY).offset(2)
    }
    
    saveButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(24)
    }
    
  }
  
  private func transferToViewController() {
    self.navigationBackButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewActionControlSubject.onNext(.didTabBack(isModified: false))
      }
      .disposed(by: disposeBag)
  }
}




