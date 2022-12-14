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
import MessageUI
import SafariServices

final class ProfileSettingViewController: UIViewController {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  let viewModel = ProfileSettingViewModel()
  let actionDetected = PublishSubject<ProfileSettingActionControl>()
  var isInRoom = true
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  //MARK: UI Components
  
  private let navigationBarView = ProfileNavigationBarView().then {
    $0.titleName.text = "설정"
  }
  
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
  
  private lazy var leavingRoomButton = UIButton().then {
    $0.setTitle("방 퇴사하기", for: .normal)
    $0.setTitleColor(Colors.red.color, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }
  
  private lazy var withdrawInfoLabel = UILabel().then {
    $0.text = "회원 탈퇴는 방 퇴사 이후 '방 만들기 화면'에서 할 수 있어요!"
    $0.textColor = Colors.g4.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
  }
  
  private lazy var withdrawButton: UIButton = {
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.setTabBarIsHidden(isHidden: true)
  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    render()
    bind()
  }
  
  init(isInRoom: Bool) {
    self.isInRoom = isInRoom
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func bind() {
    
    // input
    
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asSignal(onErrorJustReturn: ())
    
    alarmSetting.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabAlarmSetting)
      })
      .disposed(by: disposeBag)
    
    agreementInfo.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabAgreement)
      })
      .disposed(by: disposeBag)
    
    feedback.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabFeedBack)
      })
      .disposed(by: disposeBag)
    
    logoutButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabLogout)
      })
      .disposed(by: disposeBag)
    
    withdrawButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabWithdraw)
      })
      .disposed(by: disposeBag)
    
    leavingRoomButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabLeavingRoom)
      })
      .disposed(by: disposeBag)
    
    navigationBarView.navigationBackButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabBack)
      })
      .disposed(by: disposeBag)
    
    let input = ProfileSettingViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.actionControl
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.doNavigation(action: $0)
      })
      .disposed(by: disposeBag)
  }
  
  private func doNavigation(action: ProfileSettingActionControl) {
    switch action {
    case .didTabAlarmSetting:
      let destinationViewController = ProfileAlarmSettingViewController()
      self.navigationController?.pushViewController(destinationViewController, animated: true)
    case .didTabAgreement:
      presentAgreementURL()
    case .didTabFeedBack:
      presentMailSheet()
    case .didTabLogout:
      break
    case .didTabWithdraw:
      presentResignViewController()
    case .didTabLeavingRoom:
      presentLeaveViewController()
    case .didTabBack:
      setTabBarIsHidden(isHidden: false)
      self.navigationController?.popViewController(animated: true)
    }
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

extension ProfileSettingViewController {
  func presentAgreementURL() {
    let agreementURL = NSURL(string: "https://sugared-lemming-812.notion.site/6d9d478df40b4a20811e0020c15af3bc")
    let agreementSafariView: SFSafariViewController = SFSafariViewController(url: agreementURL! as URL)
    self.present(agreementSafariView, animated: true)
  }

  private func presentResignViewController() {
    let provider = ServiceProvider()
    let reactor = ResignViewReactor(provider: provider)
    let resignVC = ResignViewController(reactor)
    navigationController?.pushViewController(resignVC, animated: true)
  }

  private func presentLeaveViewController() {
    let provider = ServiceProvider()
    let reactor = ProfileLeaveViewReactor(provider: provider)
    let leaveVC = ProfileLeaveViewController(reactor)
    navigationController?.pushViewController(leaveVC, animated: true)
  }
}

extension ProfileSettingViewController: MFMailComposeViewControllerDelegate {
  func presentMailSheet() {
    if MFMailComposeViewController.canSendMail() {
      let composeViewController = MFMailComposeViewController()
      composeViewController.mailComposeDelegate = self
      
      composeViewController.setToRecipients(["hanzip001@gmail.com"])
      composeViewController.setSubject("호미나라 피드백")
      
      let deviceInfo = UIDevice.current.modelName
      let iOSVersion = UIDevice.current.systemVersion
      let currentAppVersion = currentAppVersion()
      composeViewController.setMessageBody(
        "Device : \(deviceInfo)\n" +
        "OS Version : iOS \(iOSVersion)\n" +
        "App Version : \(currentAppVersion)\n" +
        "---------------------------\n" +
        "\n\n\n" +
        "호미나라에 자유로운 피드백을 보내주세요!\n" +
        "---------------------------\n"
        , isHTML: false)
      
      self.present(composeViewController, animated: true)
    } else {
      let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
      let confirmAction = UIAlertAction(title: "확인", style: .default) {
        (action) in
        print("확인")
      }
      sendMailErrorAlert.addAction(confirmAction)
      self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
  }
  
  
  private func currentAppVersion() -> String {
    if let info: [String: Any] = Bundle.main.infoDictionary,
       let currentVersion: String
        = info["CFBundleShortVersionString"] as? String {
      return currentVersion
    }
    return "nil"
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
