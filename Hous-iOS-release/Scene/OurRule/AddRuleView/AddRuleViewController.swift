//
//  AddRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/04.
//

import UIKit
import RxSwift
import RxKeyboard
import RxGesture
import BottomSheetKit
import Kingfisher

class AddRuleViewController: LoadingBaseViewController {
  
  //MARK: - UI Components
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "새로운 Rules 추가")
    navBar.setRightButtonText(text: "저장")
    return navBar
  }()
  
  private let inValidTextLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "방 이름은 8자 이내로 입력해주세요!"
    $0.textColor = Colors.red.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }
  
  private let ruleTextField = UITextField().then {
    $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.placeholder = "Rules 입력"
  }
  
  private let textCountLabel = UILabel().then {
    $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    $0.text = "0/20"
    $0.textColor = Colors.g5.color
    $0.font = Fonts.Montserrat.medium.font(size: 12)
    $0.dynamicFont(fontSize: 12, weight: .medium)
  }
  
  private let blueLine = UIView().then {
    $0.backgroundColor = Colors.blue.color
  }
  
  private let plusButton = UIButton().then {
    $0.isUserInteractionEnabled = false
    $0.setImage(Images.icAdd.image, for: .normal)
  }
  
  private let ruleTableView = UITableView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  //MARK: - var & let
  private let maxCount = 20
  
  private let viewModel: AddRuleViewModel
  
  private let disposeBag = DisposeBag()
  
  private lazy var rulesSubject = BehaviorSubject(value: self.rules)
  
  private var newRulesSubject = PublishSubject<[String]>()
  
  private var newRules: [String] = []
  
  private var tabBarHeight: CGFloat = 83
  
  private var rules: [String]
  
  //MARK: - Lifecycle
  init(rules: [String], viewModel: AddRuleViewModel) {
    self.rules = rules
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    setTableView()
    bind()
    configButtonAction()
    setNoti()
  }
  
  //MARK: - Custom Methods
  private func setTableView() {
    ruleTableView.register(EditRuleTableViewCell.self, forCellReuseIdentifier: EditRuleTableViewCell.className)
  }
  
  private func setNoti() {
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
  }
  
  private func configUI() {
    navigationBar.updateRightButtonSnapKit()
    
    view.addSubViews([
      navigationBar,
      ruleTextField,
      blueLine,
      textCountLabel,
      plusButton,
      ruleTableView
    ])
    
    configLoadingLayout()
    
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }
    
    plusButton.snp.makeConstraints { make in
      make.centerY.equalTo(textCountLabel.snp.top).inset(11)
      make.leading.equalTo(blueLine.snp.trailing).offset(9)
      make.size.equalTo(44)
    }
    
    ruleTextField.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(32)
      make.leading.equalToSuperview().offset(25)
      make.trailing.lessThanOrEqualTo(textCountLabel.snp.leading)
    }
    
    textCountLabel.snp.makeConstraints { make in
      make.centerY.equalTo(ruleTextField)
      make.trailing.equalTo(blueLine.snp.trailing).inset(7).priority(.high)
    }
    
    blueLine.snp.makeConstraints { make in
      make.top.equalTo(ruleTextField.snp.bottom).offset(7)
      make.height.equalTo(2)
      make.leading.equalToSuperview().inset(24)
      make.trailing.equalToSuperview().inset(65)
    }
    
    ruleTableView.snp.makeConstraints { make in
      make.top.equalTo(blueLine.snp.bottom).offset(19)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
  }
  
  //MARK: - Rx
  private func bind() {
    
    rulesSubject
      .asObservable()
      .bind(to: ruleTableView.rx.items(cellIdentifier: EditRuleTableViewCell.className, cellType: EditRuleTableViewCell.self)) { row, ruleName, cell in
        cell.setTextFieldData(rule: ruleName)
        cell.isUserInteractionEnabled = false
      }
      .disposed(by: disposeBag)
    
    ruleTableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    let input = AddRuleViewModel.Input(
      navBackButtonDidTapped: navigationBar.backButton.rx.tap.asObservable(),
      viewDidTapped: view.rx.tapGesture().asObservable(),
      saveButtonDidTapped: newRulesSubject
        .do(onNext: { [weak self] _ in self?.showLoading() }),
      plusButtonDidTapped: plusButton.rx.tap.asObservable(),
      textFieldEdit: ruleTextField.rx.text
        .orEmpty
        .distinctUntilChanged()
        .asObservable()
    )
    
    
    let output = viewModel.transform(input: input)
    
    output.navBackButtonDidTapped
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        let defaultPopUpModel = DefaultPopUpModel(
          cancelText: "계속 작성하기",
          actionText: "나가기",
          title: "앗, 잠깐! 이대로 나가면\nRules가 추가되지 않아요!",
          subtitle: "정말 취소하려면 나가기 버튼을 눌러주세요."
        )
        let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: defaultPopUpModel)

        self.presentPopUp(popUpType) { [weak self] actionType in
          switch actionType {
          case .action:
            self?.navigationController?.popViewController(animated: true)
          case .cancel:
            break
          }
        }
        
      })
      .disposed(by: disposeBag)
    
    output.viewDidTapped
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.ruleTextField.endEditing(true)
      })
      .disposed(by: disposeBag)
    
    output.plusButtonDidTapped
      .drive(onNext: { [weak self] _ in
        guard let self = self,
              let text = self.ruleTextField.text
        else { return }
        
        if self.rules.count >= 30 {
          let popModel = ImagePopUpModel(
            image: .exceed,
            actionText: "알겠어요!",
            text: "우리 집 Rules가 너무 많아요!\n필요하지 않은 Rule은 삭제하고\n다시 시도해주세요~",
            titleText: "Rules 개수 초과"
          )

          let popUpType = PopUpType.exceed(exceedModel: popModel)

          self.presentPopUp(popUpType) { actionType in
            switch actionType {
            case .action:
              break
            case .cancel:
              break
            }
          }
          
        } else {
          self.rules.append(text)
          self.newRules.append(text)
          
          self.rulesSubject.onNext(self.rules)
          
          self.ruleTextField.text = ""
          self.ruleTextField.endEditing(true)
          self.ruleTableView.reloadData()
        }
        
      })
      .disposed(by: disposeBag)
    
    output.isEnableStatusOfSaveButton
      .drive(plusButton.rx.isUserInteractionEnabled)
      .disposed(by: disposeBag)
    
    output.savedCompleted
      .do(onNext: { [weak self] _ in self?.hideLoading() })
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
        
        output.textCountLabelText
          .drive(textCountLabel.rx.text)
          .disposed(by: disposeBag)
  }
  
  private func configButtonAction() {
    navigationBar.rightButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.newRulesSubject.onNext(self.newRules)
      })
      .disposed(by: disposeBag)
  }
  
}

extension AddRuleViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }
}

extension AddRuleViewController {
  
  @objc func textFieldDidChange(noti: NSNotification) {
    if let textField = noti.object as? UITextField {
      switch textField {
      case ruleTextField:
        if let text = ruleTextField.text {
          if text.count > maxCount {
            let maxIndex = text.index(text.startIndex, offsetBy: maxCount)
            let newString = String(text[text.startIndex..<maxIndex])
            ruleTextField.text = newString
          }
        }
      default:
        return
      }
    }
  }
  
}
