//
//  ProfileTestInfoViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/13.
//

import UIKit
import Network
import RxSwift
import RxCocoa

class ProfileTestInfoViewController: UIViewController {
  
  //MARK: RX Components
  
  private let disposeBag = DisposeBag()
  private let viewModel = ProfileTestInfoViewModel()
  private let actionDetected = PublishSubject<ProfileTestInfoActionControl>()
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  private var profileTestData: [ProfileDTO.Response.ProfileTestResponseDTO] = []
  
  private let testNavigationBar = ProfileTestInfoNavigationBarView()
  
  private let testStartImageView = UIImageView().then {
    $0.image = Images.illTeststart.image
  }
  
  private let testStartLabel = UILabel().then {
    $0.text = "생활패턴 체크 시작"
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.textColor = Colors.black.color
  }
  
  private let testDescriptionLabel = UILabel().then {
    $0.text = "지금부터 15개의 질문에 답변해주세요:) \n 솔직한 답변은 서로를 배려할 수 있는 \n 좋은 기회가 될거에요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g6.color
    $0.numberOfLines = 3
    $0.lineBreakMode = .byWordWrapping
    $0.lineBreakStrategy = .hangulWordPriority
    $0.textAlignment = .center
  }
  
  private lazy var startButton = UIButton().then {
    var container = AttributeContainer()
    container.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    container.foregroundColor = Colors.white.color
    
    var config = UIButton.Configuration.filled()
    config.attributedTitle = AttributedString("시작하기", attributes: container)
    config.baseBackgroundColor = Colors.blue.color
    
    $0.configuration = config
    $0.layer.cornerRadius = 5
    $0.layer.masksToBounds = true
    $0.addTarget(self, action: #selector(startProfileTest), for: .touchUpInside)
  }
  
  //MARK: Life-Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setTabBarIsHidden(isHidden: true)
    //    getProfileTest()
  }
  
  private func render() {
    self.view.addSubViews([testNavigationBar, testStartImageView, testStartLabel, testDescriptionLabel, startButton])
    
    testNavigationBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    testStartImageView.snp.makeConstraints { make in
      make.top.equalTo(testNavigationBar.snp.bottom).offset(193)
      make.centerX.equalToSuperview()
    }
    
    testStartLabel.snp.makeConstraints { make in
      make.top.equalTo(testStartImageView.snp.bottom).offset(32)
      make.centerX.equalTo(testStartImageView)
    }
    
    testDescriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(testStartLabel.snp.bottom).offset(8)
      make.centerX.equalTo(testStartImageView)
    }
    
    startButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo((Size.screenWidth - 48) * 43/327)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
    }
  }
  
  //MARK: Bind
  
  private func bind() {
    
    // input
    
    testNavigationBar.navigationBackButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabBack)
      })
      .disposed(by: disposeBag)
    
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asSignal(onErrorJustReturn: ())
    
    let input = ProfileTestInfoViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected)
    
    // output
    let output = viewModel.transform(input: input)
    
    output.actionControl
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] action in
        guard let self = self else { return }
        self.doNavigation(action: action)
      })
      .disposed(by: disposeBag)
  }
  
  
  //MARK: Methods
  
  private func doNavigation(action: ProfileTestInfoActionControl) {
    switch action {
    case .didTabBack:
      setTabBarIsHidden(isHidden: false)
      self.navigationController?.popViewController(animated: true)
      
    default:
      return
    }
  }
}
  
  //MARK: Objective-C Methods
  extension ProfileTestInfoViewController {
    @objc private func startProfileTest() {
      let profileTest = ProfileTestViewController()
      profileTest.modalTransitionStyle = .crossDissolve
      profileTest.modalPresentationStyle = .fullScreen
      
      present(profileTest, animated: true)
    }
  }
  
  //MARK: Network
  //extension ProfileTestInfoViewController {
  //  private func getProfileTest() {
  //    ProfileTestAPIService.shared.requestGetTypeTest { result in
  //
  //      if let responseResult = NetworkResultFactory.makeResult(resultType: result)
  //          as? Success<TypeTestsDTO> {
  //        guard let response = responseResult.response else { return }
  //
  //        self.profileTestData = response.typeTests
  //
  //      } else {
  //        let responseResult = NetworkResultFactory.makeResult(resultType: result)
  //        responseResult.resultMethod()
  //      }
  //
  //    }
  //  }
  //}
