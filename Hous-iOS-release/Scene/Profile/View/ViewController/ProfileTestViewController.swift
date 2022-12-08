//
//  ProfileTestViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit
import BottomSheetKit
import Then
import RxSwift
import RxCocoa

final class ProfileTestViewController: LoadingBaseViewController {
  
  private var testIndex = 0
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  var viewModel = ProfileTestViewModel()
  var data: [ProfileTestItemModel] = []
  let actionDetected = PublishSubject<ProfileTestActionControl>()
  private var latestAction: ProfileTestActionControl = .none
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  private enum QuestionType: String {
    case light = "LIGHT"
    case noise = "NOISE"
    case smell = "SMELL"
    case introversion = "INTROVERSION"
    case clean = "CLEAN"
    case none = "NONE"
  }
  
  //MARK: UI Components
  
  private lazy var backwardButton = UIButton().then {
    $0.setImage(Images.icLeft.image, for: .normal)
    $0.setImage(Images.icLeftOn.image, for: .selected)
    $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.isEnabled = false
    $0.alpha = 0
  }
  
  private let testCountLabel = UILabel().then {
    $0.font = Fonts.Montserrat.bold.font(size: 16)
    $0.textColor = Colors.black.color
  }
  
  private lazy var forwardButton = UIButton().then {
    $0.setImage(Images.icRight.image, for: .normal)
    $0.setImage(Images.icRightOn.image, for: .selected)
    $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.isEnabled = false
    $0.alpha = 0
  }
  
  private lazy var testNavigationStackView = UIStackView(arrangedSubviews: [backwardButton, testCountLabel, forwardButton]).then {
    $0.axis = .horizontal
    $0.spacing = 30
  }
  
  private lazy var quitButton = UIButton().then {
    var container = AttributeContainer()
    container.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    
    var config = UIButton.Configuration.plain()
    config.baseForegroundColor = Colors.g4.color
    config.attributedTitle = AttributedString("그만두기", attributes: container)
    config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0)
    
    $0.configuration = config
  }
  
  private let testCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    var layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    $0.isPagingEnabled = true
    $0.isScrollEnabled = false
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
  }
  
  
  // LIGHT, NOISE, SMELL, INTROVERSION, CLEAN
  
  
  var isMovedBackward: Bool = false
  
  private var indexPathRow: Int?
  
  var isAnimationing: Bool = false
  
  //MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    setTestCollectionView()
    configUI()
    configLoadingLayout()
    self.showLoading()
    bind()
  }
  
  //MARK: Setup UI
  
  private func configUI() {
    testCountLabel.text = "1 / \(data.count)"
  }
  
  private func setTestCollectionView() {
    testCollectionView.register(cell: TestCollectionViewCell.self)
    testCollectionView.delegate = self
  }
  
  //MARK: Bind
  
  private func bind() {
    
    // input
    
    let viewWillAppear = rx.RxViewWillAppear
      .asSignal(onErrorJustReturn: ())
  
    
    forwardButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabForward)
      })
      .disposed(by: disposeBag)
    
    backwardButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabBackward)
      })
      .disposed(by: disposeBag)
    
    quitButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabQuit)
      })
      .disposed(by: disposeBag)
    
    let input = ProfileTestViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.profileTestData
      .do(onNext: { _ in
          self.hideLoading()
        })
      .bind(to: testCollectionView.rx.items) {
            (collectionView: UICollectionView, index: Int, element: ProfileTestItemModel) in
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell =
                    self.testCollectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.className , for: indexPath) as? TestCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
            cell.cellIndex = indexPath.row
            cell.transferToViewController(cellIndex: cell.cellIndex)
            cell.bind(element, self.viewModel.selectedData)
            cell.cellActionControlSubject
              .asDriver(onErrorJustReturn: .none)
              .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                self.actionDetected.onNext(data)
              })
              .disposed(by: cell.disposeBag)
            return cell
          }
          .disposed(by: disposeBag)
    
    output.profileTestData
      .bind(onNext: { [weak self] data in
        guard let self = self else { return }
        self.data = data
        self.testCollectionView.reloadData()
        self.testCountLabel.text = "1 / \(data.count)"
      })
      .disposed(by: disposeBag)
    
    output.selectedDataObservable
      .bind(onNext: { [weak self] data in
        guard let self = self else { return }
        self.selectedLogicControl(data: data)
      })
      .disposed(by: disposeBag)
    
    output.actionControl
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] action in
        guard let self = self else { return }
        switch action {
        case let .didTabAnswer(_, questionNum):
          if self.latestAction == action {
            self.testCountLabel.text = "\(questionNum + 1) / \(self.data.count)"
            break
          }
          self.testCollectionView.reloadData()
          self.scrollForward()
          self.viewModel.selectedDataSubject.onNext(self.viewModel.selectedData)
        case .didTabBackward:
          self.testCollectionView.reloadData()
          self.scrollBackward()
          self.viewModel.selectedDataSubject.onNext(self.viewModel.selectedData)
        case .didTabForward:
          self.testCollectionView.reloadData()
          self.scrollForward()
          self.viewModel.selectedDataSubject.onNext(self.viewModel.selectedData)
        case .didTabQuit:
          self.showQuitPopUp()
        case .didTabFinish:
          self.finishTest()
        default:
          break
        }
        self.latestAction = action
      })
      .disposed(by: disposeBag)
  }
  
  private func render() {
    self.view.addSubViews([testNavigationStackView, quitButton, testCollectionView])
    
    testNavigationStackView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      make.centerX.equalToSuperview()
    }
    
    quitButton.snp.makeConstraints { make in
      make.centerY.equalTo(testNavigationStackView)
      make.trailing.equalToSuperview().inset(24)
    }
    
    testCollectionView.snp.makeConstraints { make in
      make.top.equalTo(testNavigationStackView.snp.bottom).offset(30)
      make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func setButtonIsEnabled(_ button: UIButton, isEnabled flag: Bool) {
    button.alpha = flag ? 1 : 0
    button.isEnabled = flag
  }
  
  private func selectedLogicControl(data: [Int]) {
    if self.testIndex >= data.count { return }
    
    if data[self.testIndex] != 0 {
      setButtonIsEnabled(forwardButton, isEnabled: true)
    } else {
      setButtonIsEnabled(forwardButton, isEnabled: false)
    }
    if self.testIndex == 0 {
      setButtonIsEnabled(backwardButton, isEnabled: false)
    } else {
      setButtonIsEnabled(backwardButton, isEnabled: true)
    }
    
    if self.testIndex == 14 && data.contains(0) {
      setButtonIsEnabled(forwardButton, isEnabled: false)
    }
  }
  
  private func scrollBackward() {
    if testIndex <= 0 { return }
    testIndex -= 1
    testCollectionView.scrollToItem(at: IndexPath(row: testIndex, section: 0), at: .left, animated: true)
    testCountLabel.text = "\(testIndex + 1) / \(data.count)"
  }
  
  private func scrollForward() {
    testIndex += 1
    if testIndex == data.count {
      actionDetected.onNext(.didTabFinish)
      return
    }
    testCollectionView.scrollToItem(at: IndexPath(row: testIndex, section: 0), at: .right, animated: true)
    testCountLabel.text = "\(testIndex + 1) / \(data.count)"
  }
  
  private func showQuitPopUp() {
    let quitTestPopUpModel = DefaultPopUpModel(
      cancelText: "계속하기",
      actionText: "그만두기",
      title: "테스트를 완료하지 않았어요\n여기서 그만둘까요?",
      subtitle: "나중에 다시 할 수 있어요.")
    
    let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: quitTestPopUpModel)
    
    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        let housTabbarViewController = HousTabbarViewController()
        
        self?.view.window?.rootViewController = housTabbarViewController
        self?.view.window?.makeKeyAndVisible()
        
        housTabbarViewController.housTabBar.selectItem(index: 2)
        self?.dismiss(animated: true)
      case .cancel:
        break
      }
    }
  }
  
  private func finishTest() {
    let destinationViewController = ProfileTestLoadingViewController()
    destinationViewController.profileTestSaveData = ProfileTestSaveModel(selectedData: viewModel.selectedData, questionType: viewModel.questionTypes)
    destinationViewController.modalPresentationStyle = .fullScreen
    destinationViewController.modalTransitionStyle = .crossDissolve
    self.present(destinationViewController, animated: true)
  }
}

extension ProfileTestViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: Size.screenWidth, height: testCollectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

//MARK: Objective-C methods


extension ProfileTestViewController {
  
  private func updateTest(typeScore: [Int], completion: @escaping () -> Void) {
    //    ProfileTestAPIService.shared.requestUpdateTest(typeScore: typeScore) { result in
    //      if let responseResult = NetworkResultFactory.makeResult(resultType: result)
    //          as? Success<UpdateTestDTO> {
    //        responseResult.resultMethod()
    //
    //        completion()
    //      } else {
    //        let responseResult = NetworkResultFactory.makeResult(resultType: result)
    //        responseResult.resultMethod()
    //      }
    //    }
  }
}



