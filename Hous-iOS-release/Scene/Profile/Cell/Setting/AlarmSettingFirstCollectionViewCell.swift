//
//  AlarmSettingFirstCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/10.
//



import UIKit
import RxSwift
import RxCocoa

final class AlarmSettingFirstCollectionViewCell: UICollectionViewCell {
  
//  var settingData: AlarmSettingModel
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
    
  private let cellTitleLabel = UILabel().then {
    $0.text = "알림 받기"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }
  
  private let pushNotificationSwitch = UISwitch().then {
    $0.onTintColor = Colors.blue.color
  }
  
  override init(frame: CGRect){
    super.init(frame: frame)
    configUI()
    render()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI() {
    self.backgroundColor = .white
  }
  
  private func render() {
    self.addSubViews([cellTitleLabel, pushNotificationSwitch])
    
    cellTitleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(24)
    }
    
    pushNotificationSwitch.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-16)
    }
  }
  
  func bind(data: AlarmSettingModel) {
    self.pushNotificationSwitch.isOn = data.isPushNotification ? true : false
  }
  
}
