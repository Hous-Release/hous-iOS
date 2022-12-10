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
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.doNavigation(action: $0)
      })
      .disposed(by: disposeBag)
  }
  
  private func doNavigation(action: ProfileSettingActionControl) {
    switch action {
    case .didTabAlarmSetting:
      break
    case .didTabAgreement:
      presentAgreementURL()
    case .didTabFeedBack:
      presentMailSheet()
    case .didTabLogout:
      break
    case .didTabWithdraw:
      presentResignViewController()
    case .didTabLeavingRoom:
      break
    case .didTabBack:
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
  
  func getModelName() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let model = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    switch model {
      // Simulator
    case "i386", "x86_64":                          return "Simulator"
      // iPod
    case "iPod1,1":                                 return "iPod Touch"
    case "iPod2,1", "iPod3,1", "iPod4,1":           return "iPod Touch"
    case "iPod5,1", "iPod7,1":                      return "iPod Touch"
      // iPad
    case "iPad1,1":                                 return "iPad"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
    case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
    case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
    case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
    case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
    case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
    case "iPad6,11", "iPad6,12":                    return "iPad 5"
    case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
    case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
    case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
    case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
      // iPhone
    case "iPhone1,1", "iPhone1,2", "iPhone2,1":     return "iPhone"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
    case "iPhone4,1":                               return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
    case "iPhone7,1":                               return "iPhone 6 Plus"
    case "iPhone7,2":                               return "iPhone 6"
    case "iPhone8,1":                               return "iPhone 6s"
    case "iPhone8,2":                               return "iPhone 6s Plus"
    case "iPhone8,4":                               return "iPhone SE"
    case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
    case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
    case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
    case "iPhone10,3", "iPhone10,6":                return "iPhone X"
    case "iPhone11,2":                              return "iPhone XS"
    case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
    case "iPhone11,8":                              return "iPhone XR"
    case "iPhone12,1":                              return "iPhone 11"
    case "iPhone12,3":                              return "iPhone 11 Pro"
    case "iPhone12,5":                              return "iPhone 11 Pro Max"
    case "iPhone12,8":                              return "iPhone SE 2nd Gen"
    case "iPhone13,1":                              return "iPhone 12 Mini"
    case "iPhone13,2":                              return "iPhone 12"
    case "iPhone13,3":                              return "iPhone 12 Pro"
    case "iPhone13,4":                              return "iPhone 12 Pro Max"
    case "iPhone14,2":                              return "iPhone 13 Pro"
    case "iPhone14,3":                              return "iPhone 13 Pro Max"
    case "iPhone14,4":                              return "iPhone 13 Mini"
    case "iPhone14,5":                              return "iPhone 13"
    case "iPhone14,6":                              return "iPhone SE 3rd Gen"
    case "iPhone14,7":                              return "iPhone 14"
    case "iPhone14,8":                              return "iPhone 14 Plus"
    case "iPhone15,2":                              return "iPhone 14 Pro"
    case "iPhone15,3":                              return "iPhone 14 Pro Max"
    default:                                        return model
    }
  }
  
  func currentAppVersion() -> String {
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
