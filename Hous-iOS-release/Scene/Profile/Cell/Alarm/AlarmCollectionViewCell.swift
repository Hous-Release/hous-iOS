//
//  AlarmCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/14.
//

import UIKit
import RxSwift
import RxCocoa

final class AlarmCollectionViewCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<ProfileAlarmActionControl>()
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  private let alarmTypeImageView = UIImageView()
  
  private let alarmTypeLabel = UILabel().then {
    $0.textColor = Colors.g5.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }
  
  private let timeLabel = UILabel().then {
    $0.textColor = Colors.g3.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = Colors.g7.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }
  
  private let grayLineView = UIView().then {
    $0.backgroundColor = Colors.g2.color
  }
  
  
  override init(frame: CGRect){
    super.init(frame: frame)
    configUI()
    render()
    transferToViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
    transferToViewController()
  }
  
  private func configUI() {
    self.backgroundColor = .white
  }
  
  private func transferToViewController() {
    
  }
  
  private func render() {
    self.addSubViews([alarmTypeImageView, alarmTypeLabel, timeLabel, contentLabel, grayLineView])
    
    alarmTypeImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(24)
      make.width.height.equalTo(20)
    }
    
    alarmTypeLabel.snp.makeConstraints { make in
      make.centerY.equalTo(alarmTypeImageView)
      make.leading.equalTo(alarmTypeImageView.snp.trailing).offset(8)
    }
    
    timeLabel.snp.makeConstraints { make in
      make.centerY.equalTo(alarmTypeImageView)
      make.trailing.equalToSuperview().offset(-23)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.top.equalTo(alarmTypeLabel.snp.bottom).offset(12)
    }
    
    grayLineView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
  }
  
  func bind(data: AlarmModel) {
    
    switch data.type {
    case .todo:
      alarmTypeImageView.image = Images.icNotiTodo.image
      alarmTypeLabel.text = "To-Do"
    case .rules:
      alarmTypeImageView.image = Images.icNotiRules.image
      alarmTypeLabel.text = "Rules"
    case .badge:
      alarmTypeImageView.image = Images.icNotiBadge.image
      alarmTypeLabel.text = "Badge"
    }
    
    timeLabel.text = data.createdAt
    
    contentLabel.text = data.content
    
    if !data.isRead {
      self.backgroundColor = Colors.blueL2.color
    }
  }
  
}
