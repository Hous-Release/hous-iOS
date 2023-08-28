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
import BottomSheetKit
import HousUIComponent

final class ProfileSettingViewController: UIViewController {

  // MARK: RX Components

  let disposeBag = DisposeBag()
  let viewModel = ProfileSettingViewModel()
  let actionDetected = PublishSubject<ProfileSettingActionControl>()
  let provider = ServiceProvider()
  var isInRoom = true
  let profileRepository = ProfileRepositoryImp()

  // MARK: UI Templetes

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }

  // MARK: UI Components

  private let navigationBarView = NavBarWithBackButtonView(
    title: "설정",
    rightButtonText: "",
    isSeparatorLineHidden: false)

  private let settingListStackView = UIStackView().then {
    $0.alignment = .fill
    $0.distribution = .fill
    $0.axis = .vertical
  }

  private let alarmSetting = ProfileSettingListView(color: Colors.black.color, text: "알림")

  private let agreementInfo = ProfileSettingListView(color: Colors.black.color, text: "개인정보 및 약관")

  private let licenseInfo = ProfileSettingListView(color: Colors.black.color, text: "오픈소스 라이브러리")

  private let feedback = ProfileSettingListView(color: Colors.black.color, text: "호미나라 피드백 보내기")

  private let logoutButton = ProfileSettingListView(color: Colors.black.color, text: "로그아웃")

  private lazy var leavingRoomButton = ProfileSettingListView(color: Colors.red.color, text: "방 퇴사하기")

  private lazy var withdrawButton = ProfileSettingListView(color: Colors.red.color, text: "회원탈퇴")

  private lazy var withdrawInfoLabel = UILabel().then {
    $0.text = "회원 탈퇴는 방 퇴사 이후 '방 만들기 화면'에서 할 수 있어요!"
    $0.textColor = Colors.g4.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.setTabBarIsHidden(isHidden: true)
  }

  override func viewDidLoad() {
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

    licenseInfo.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabLicense)
      })
      .disposed(by: disposeBag)

    feedback.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabFeedBack)
      })
      .disposed(by: disposeBag)

    logoutButton.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabLogout)
      })
      .disposed(by: disposeBag)

    withdrawButton.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabWithdraw)
      })
      .disposed(by: disposeBag)

    leavingRoomButton.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabLeavingRoom)
      })
      .disposed(by: disposeBag)

    navigationBarView.backButton.rx.tap
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
      doLogout()
    case .didTabWithdraw:
      presentResignViewController()
    case .didTabLeavingRoom:
      presentLeaveViewController()
    case .didTabBack:
      setTabBarIsHidden(isHidden: false)
      self.navigationController?.popViewController(animated: true)
    case .didTabLicense:
      presentLicenseURL()
    }
  }

  private func render() {
    [alarmSetting, agreementInfo, licenseInfo, feedback, logoutButton].forEach {
      settingListStackView.addArrangedSubview($0)
    }

    view.addSubViews([navigationBarView, settingListStackView])

    navigationBarView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }

    settingListStackView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom).offset(7)
      make.leading.trailing.equalToSuperview()
    }

    if isInRoom {
      settingListStackView.addArrangedSubview(leavingRoomButton)
      view.addSubview(withdrawInfoLabel)

      withdrawInfoLabel.snp.makeConstraints { make in
        make.top.equalTo(settingListStackView.snp.bottom).offset(20)
        make.leading.trailing.equalToSuperview().inset(24)
      }
    } else {
      settingListStackView.addArrangedSubview(withdrawButton)
    }
  }
}

extension ProfileSettingViewController {

  private func doLogout() {
    let logoutButtonPopUpModel = DefaultPopUpModel(
      cancelText: "취소하기",
      actionText: "로그아웃",
      title: "정말 로그아웃 하시겠어요?",
      subtitle: "다시 로그인하면 현재 방을 계속 사용할 수 있어요."
    )

    let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: logoutButtonPopUpModel)

    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        let serviceProvider = ServiceProvider()
        let reactor = SignInReactor(provider: serviceProvider)
        let signInViewController = SignInViewController(reactor)
        self?.provider.authRepository.logout()
        self?.view.window?.rootViewController = signInViewController
        self?.view.window?.makeKeyAndVisible()
        self?.view.window?.rootViewController?.dismiss(animated: true)
      case .cancel:
        break
      }
    }
  }

  func presentLicenseURL() {
    let licenseURL = NSURL(string: "https://sugared-lemming-812.notion.site/iOS-f772bcb865e14f2c9053c1fe482da499")
    let licenseSafariView: SFSafariViewController = SFSafariViewController(url: licenseURL! as URL)
    self.present(licenseSafariView, animated: true)
  }

  func presentAgreementURL() {
    let agreementURL = NSURL(string: "https://sugared-lemming-812.notion.site/6d9d478df40b4a20811e0020c15af3bc")
    let agreementSafariView: SFSafariViewController = SFSafariViewController(url: agreementURL! as URL)
    self.present(agreementSafariView, animated: true)
  }

  private func presentResignViewController() {
    let provider = ServiceProvider()
    let reactor = ConfirmRemoveProfileReactor()
    let removeProfileVC = ConfirmRemoveProfileViewController(reactor)
    navigationController?.pushViewController(removeProfileVC, animated: true)
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
      let sendMailErrorAlert = UIAlertController(
        title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
      let confirmAction = UIAlertAction(title: "확인", style: .default) {
        (_) in
//        print("확인")
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

  func mailComposeController(_ controller: MFMailComposeViewController,
                             didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .saved:
      Toast.show(message: "피드백 메일이 임시 저장되었어요!", controller: self)
    case .failed:
      Toast.show(message: "피드백 메일이 전송에 실패했어요!", controller: self)
    case .sent:
      Toast.show(message: "피드백 메일이 정상적으로 보내졌어요!", controller: self)
      profileRepository.postFeedbackBadge()
    case .cancelled:
      Toast.show(message: "피드백 전송을 취소했어요!", controller: self)
    @unknown default:
      fatalError()
    }
    controller.dismiss(animated: true, completion: nil)
  }
}
