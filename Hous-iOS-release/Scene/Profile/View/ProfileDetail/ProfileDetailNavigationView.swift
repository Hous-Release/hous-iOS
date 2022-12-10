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
  var isFromTypeTest: Bool = false
  
  private lazy var navigationBackButton = UIButton().then {
    $0.setImage(Images.icBack.image, for: .normal)
  }
  
  private lazy var testCompleteButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(Colors.blue.color, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }
  
  private let titleName = UILabel().then {
    $0.text = "성향 자세히 보기"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.textAlignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(isFromTypeTest: Bool) {
    self.init(frame: .zero)
    self.isFromTypeTest = isFromTypeTest
    render()
    setup()
    transferToViewController()
  }
  
  private func setup() {
    self.backgroundColor = .white
  }
  
  private func render() {
    self.addSubView(titleName)
    
    titleName.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(2)
    }
    
    if self.isFromTypeTest {
      self.addSubView(testCompleteButton)
      
      testCompleteButton.snp.makeConstraints { make in
        make.centerY.equalToSuperview()
        make.trailing.equalToSuperview().inset(32)
      }
    } else {
      self.addSubView(navigationBackButton)
      
      navigationBackButton.snp.makeConstraints {make in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().inset(24)
      }
    }
  }
  
  private func transferToViewController() {
    self.navigationBackButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewActionControlSubject.onNext(.didTabBack)
      }
      .disposed(by: disposeBag)
    
    self.testCompleteButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewActionControlSubject.onNext(.didTabBack)
      }
      .disposed(by: disposeBag)
  }
}



