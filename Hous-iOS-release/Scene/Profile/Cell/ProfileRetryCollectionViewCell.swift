//
//  ProfileRetryCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/18.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileRetryCellDelegate: AnyObject {
  func didTabRetry()
}

final class ProfileRetryCollectionViewCell: UICollectionViewCell {
  
  private let disposeBag: DisposeBag = DisposeBag()
  weak var delegate: ProfileRetryCellDelegate?
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var retryTitleLabel = UILabel().then {
    $0.text = "내가 아닌 거 같은데?"
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textAlignment = .center
  }

  private let retryButton = UIButton().then {
    $0.setTitle("다시 검사해보기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.backgroundColor = Colors.black.color
    $0.layer.cornerRadius = 8
  }
  
  
  
  //MARK: Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
    transferToViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .white
  }
  
  private func render() {
    
    [retryTitleLabel, retryButton].forEach { addSubview($0) }
    
    retryTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(32)
      make.centerX.equalToSuperview()
    }
    
    retryButton.snp.makeConstraints { make in
      make.top.equalTo(retryTitleLabel.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.width.equalTo(Size.screenWidth - 48)
      make.height.equalTo(43)
    }
    
  }
  
  private func transferToViewController() {
    self.retryButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.delegate?.didTabRetry()
      }
      .disposed(by: disposeBag)
  }
  
  func bind(_ data: ProfileModel) {
    
  }
}
