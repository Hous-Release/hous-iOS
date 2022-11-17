//
//  ProfileTestInfoNavigationView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/15.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileTestInfoNavigationBarView: UIView {
  
  private let disposeBag: DisposeBag = DisposeBag()
  let viewActionControlSubject = PublishSubject<ProfileTestInfoActionControl>()
  
  let navigationBackButton = UIButton().then {
    $0.setImage(Images.icBack.image, for: .normal)
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
    self.addSubView(navigationBackButton)
    
    navigationBackButton.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(24)
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



