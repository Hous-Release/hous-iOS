//
//  ProfileSettingViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class ProfileSettingViewController: UIViewController {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  let viewModel = ProfileSettingViewModel()
  var isInRoom = true
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  //MARK: UI Components
  
  private let navigationBarView = ProfileSettingNavigationBarView()
  
  private let settingListStackView = UIStackView().then {
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.axis = .vertical
  }
  
  private let alarmSetting = ProfileSettingListView(image: Images.icAlarmSetting.image, text: "알람")
  
  private let agreementInfo = ProfileSettingListView(image: Images.icInfo.image, text: "개인정보 및 약관")
  
  private let feedback = ProfileSettingListView(image: Images.icFeedback.image, text: "호미나라 피드백 보내기")
  
  private var grayLineView = UIView().then {
    $0.backgroundColor = Colors.g2.color
  }
  
  private let labelButtonStackView = UIStackView().then {
    $0.alignment = .leading
    $0.distribution = .equalSpacing
    $0.axis = .vertical
    $0.spacing = 5
  }
  
  private let logoutButton = UIButton().then {
    $0.setTitle("로그아웃", for: .normal)
    $0.setTitleColor(Colors.black.color, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }
  
  private let leavingRoomButton = UIButton().then {
    $0.setTitle("방 퇴사하기", for: .normal)
    $0.setTitleColor(Colors.red.color, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }
  
  private let withdrawInfoLabel = UILabel().then {
    $0.text = "회원 탈퇴는 방 퇴사 이후 '방 만들기 화면'에서 할 수 있어요!"
    $0.textColor = Colors.g4.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
  }
  
  private var withdrawButton: UIButton = {
    let button = UIButton()
    let attributedString = NSAttributedString(string:
    NSLocalizedString("회원 탈퇴", comment: ""), attributes: [
      NSAttributedString.Key.font: Fonts.SpoqaHanSansNeo.medium.font(size: 13),
      NSAttributedString.Key.foregroundColor: Colors.g4.color,
      NSAttributedString.Key.underlineStyle: 1.0,
      NSAttributedString.Key.underlineColor: Colors.g4.color
    ])
    button.setAttributedTitle(attributedString, for: .normal)
    return button
  }()
  
  
  override func viewDidLoad(){
    super.viewDidLoad()
    render()
  }
  
  init(isInRoom: Bool) {
    self.isInRoom = isInRoom
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func render() {
    [alarmSetting, agreementInfo, feedback].forEach {
      settingListStackView.addArrangedSubview($0)
    }
    
    labelButtonStackView.addArrangedSubview(logoutButton)
    
    view.addSubViews([navigationBarView, settingListStackView, grayLineView, labelButtonStackView])
    
    navigationBarView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    settingListStackView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom).offset(7)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(160)
    }
    
    grayLineView.snp.makeConstraints { make in
      make.top.equalTo(settingListStackView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(1)
    }
    
    labelButtonStackView.snp.makeConstraints { make in
      make.top.equalTo(grayLineView.snp.bottom).offset(19)
      make.leading.trailing.equalToSuperview().inset(24)
    }
    
    if isInRoom {
      labelButtonStackView.addArrangedSubview(leavingRoomButton)
      view.addSubview(withdrawInfoLabel)
      
      withdrawInfoLabel.snp.makeConstraints { make in
        make.top.equalTo(labelButtonStackView.snp.bottom).offset(20)
        make.leading.trailing.equalToSuperview().inset(24)
      }
    } else {
      view.addSubview(withdrawButton)
      withdrawButton.snp.makeConstraints { make in
        make.top.equalTo(labelButtonStackView.snp.bottom).offset(12)
        make.leading.equalToSuperview().offset(24)
      }
    }
  }
}
