//
//  ProfileRetryViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit
import BottomSheetKit

final class ProfileTestViewController: UIViewController {

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }

  private enum QuestionType: String {
    case light = "LIGHT"
    case noise = "NOISE"
    case smell = "SMELL"
    case personality = "PERSONALITY"
    case clean = "CLEAN"
    case none = "NONE"
  }

  // LIGHT, NOISE, SMELL, PERSONAITY, CLEAN
  var profileTestCellData: [ProfileTestCellItem]

  private lazy var questionTypeScoreList = [ProfileTest](repeating: ProfileTest(testType: QuestionType.none.rawValue, score: 0), count: profileTestCellData.count)

  private lazy var finalScore = [Int](repeating: 0, count: 5)

  private var testIndex = 0

  var isMovedBackward: Bool = false

  private var indexPathRow: Int?

  private lazy var backwardButton = UIButton().then {
    $0.setImage(Images.icLeft.image, for: .normal)
    $0.setImage(Images.icLeftOn.image, for: .selected)
    $0.addTarget(self, action: #selector(scrollBackward), for: .touchUpInside)
  }

  private let testCountLabel = UILabel().then {
    $0.font = Fonts.Montserrat.bold.font(size: 16)
    $0.textColor = Colors.black.color
  }

  private lazy var forwardButton = UIButton().then {
    $0.setImage(Images.icRight.image, for: .normal)
    $0.setImage(Images.icRightOn.image, for: .selected)
    $0.addTarget(self, action: #selector(scrollForward), for: .touchUpInside)
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
    config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    $0.configuration = config
    $0.addTarget(self, action: #selector(showQuitTestPopUp), for: .touchUpInside)
  }

  private let testCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    var layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal

    $0.isPagingEnabled = true
    $0.isScrollEnabled = false
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
  }

  var isAnimationing: Bool = false

  init(profileTestCellItems: [ProfileTestCellItem]) {
    self.profileTestCellData = profileTestCellItems
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    setTestCollectionView()
    configUI()
  }

  private func configUI() {
    testCountLabel.text = "1 / \(profileTestCellData.count)"
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

  private func setTestCollectionView() {
    testCollectionView.register(cell: TestCollectionViewCell.self)
    testCollectionView.delegate = self
    testCollectionView.dataSource = self
  }

  private func setButtonIsEnabled(_ button: UIButton, isEnabled flag: Bool) {
    button.alpha = flag ? 1 : 0
    button.isEnabled = flag
  }


  private func setNotChoosedView(index: Int) {
    if index == 1 {
      setButtonIsEnabled(backwardButton, isEnabled: false)
      setButtonIsEnabled(forwardButton, isEnabled: false)
    } else {
      setButtonIsEnabled(backwardButton, isEnabled: true)
      setButtonIsEnabled(forwardButton, isEnabled: false)
    }
  }

  private func setChoosedView(index: Int) {
    if index == 1 {
      setButtonIsEnabled(backwardButton, isEnabled: false)
      setButtonIsEnabled(forwardButton, isEnabled: true)
    } else if index == profileTestCellData.count {
      setButtonIsEnabled(backwardButton, isEnabled: true)
      setButtonIsEnabled(forwardButton, isEnabled: false)
    } else {
      setButtonIsEnabled(backwardButton, isEnabled: true)
      setButtonIsEnabled(forwardButton, isEnabled: true)
    }
  }

  private func checkViewState(index: Int) -> (Bool) {
    if questionTypeScoreList[index - 1].score == 0 { return false }
    else { return true }
  }

  private func setBackforwardButton(index: Int) {
    if checkViewState(index: index) { setChoosedView(index: index) }
    else { setNotChoosedView(index: index) }
  }
}

extension ProfileTestViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return profileTestCellData.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = testCollectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.className, for: indexPath) as? TestCollectionViewCell
    else { return UICollectionViewCell() }

    cell.delegate = self

    cell.setTestData(profileTestCellData[indexPath.row])
    setBackforwardButton(index: indexPath.row + 1)

    return cell
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
  @objc private func showQuitTestPopUp() {
    let quitTestPopUpModel = DefaultPopUpModel(
      cancelText: "계속하기",
      actionText: "그만두기",
      title: "테스트를 완료하지 않았어요\n여기서 그만둘까요?",
      subtitle: "나중에 다시 할 수 있어요.")
    
    let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: quitTestPopUpModel)
    
    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        self?.navigationController?.popViewController(animated: true)
      case .cancel:
        break
      }
    }
  }

  @objc private func scrollBackward() {

    if testIndex <= 0 { return }

    testIndex -= 1

    isMovedBackward = true

    testCollectionView.scrollToItem(at: IndexPath(row: testIndex, section: 0), at: .left, animated: true)

    setBackforwardButton(index: testIndex + 1)

    testCountLabel.text = "\(testIndex + 1) / \(profileTestCellData.count)"
  }

  @objc private func scrollForward() {

    testIndex += 1

    if testIndex == profileTestCellData.count {
      return
    }

    isMovedBackward = false

    setBackforwardButton(index: testIndex + 1)

    testCollectionView.scrollToItem(at: IndexPath(row: testIndex, section: 0), at: .right, animated: true)

    testCountLabel.text = "\(testIndex + 1) / \(profileTestCellData.count)"
  }
}

extension ProfileTestViewController: TestCollectionViewCellDelegate {

  func optionButtonDidTapped(_ sender: UIButton, _ tag: Int ) {

    if testIndex + 1 == profileTestCellData.count {

      let type = profileTestCellData[testIndex].testType
      let score = tag + 1

      questionTypeScoreList[testIndex] = ProfileTest(testType: type, score: score)

      for item in questionTypeScoreList {
        switch item.questionType {
        case QuestionType.light.rawValue : finalScore[0] += item.score
        case QuestionType.noise.rawValue : finalScore[1] += item.score
        case QuestionType.smell.rawValue : finalScore[2] += item.score
        case QuestionType.personality.rawValue : finalScore[3] += item.score
        case QuestionType.clean.rawValue : finalScore[4] += item.score
        default:
          break
        }
      }

      // deselect all buttons
      profileTestCellData[testIndex].testAnswers.forEach {
        $0.deselectIsSelected()
      }

      // select button -> true
      self.profileTestCellData[testIndex].testAnswers[tag].isSelected = true

      // 나의 테스트 성향 점수 변경
      self.updateTest(typeScore: finalScore) {
        let testResultVC = ProfileDetailViewController(color: .purple) // #temp
        testResultVC.modalPresentationStyle = .fullScreen
        self.present(testResultVC, animated: true)
        return
      }

    } else {

      let type = profileTestCellData[testIndex].testType
      let score = tag + 1

      questionTypeScoreList[testIndex] = ProfileTest(testType: type, score: score)
      testIndex += 1

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in

        testCollectionView.scrollToItem(at: IndexPath(row: testIndex, section: 0), at: .right, animated: true)

        testCountLabel.text = "\(testIndex + 1) / \(profileTestCellData.count)"

        // deselect all buttons
        profileTestCellData[testIndex - 1].testAnswers.forEach {
          $0.deselectIsSelected()
        }

        // select button -> true
        profileTestCellData[testIndex - 1].testAnswers[tag].isSelected = true

        setBackforwardButton(index: testIndex + 1)
      }
    }
  }
}

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



