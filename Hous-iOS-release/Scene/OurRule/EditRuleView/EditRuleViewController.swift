//
//  EditRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxKeyboard
import Network
import BottomSheetKit

class EditRuleViewController: UIViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "Rules 수정")
    navBar.setRightButtonText(text: "저장")
    return navBar
  }()
  
  private let rulesTableView = UITableView().then {
    $0.showsVerticalScrollIndicator = false
    $0.allowsSelectionDuringEditing = true
    $0.isEditing = true
  }
  
  private let ruleEmptyViewLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "아직 우리 집 Rules가 없어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
  }
  
  private let disposeBag = DisposeBag()
  
  private let saveButtonDidTapped = PublishSubject<[RuleWithIdViewModel]>()
  
  private let viewDidTapped = PublishSubject<Void>()
  
  private var editViewRules: [RuleWithIdViewModel]
  
  private let viewModel: EditRuleViewModel
  
  private var tabBarHeight: CGFloat = 83
  
  init(editViewRules: [RuleWithIdViewModel], viewModel: EditRuleViewModel) {
    self.editViewRules = editViewRules
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTableView()
    configUI()
    bind()
    configButtonAction()
  }
  
  private func setTableView() {
    rulesTableView.register(EditRuleTableViewCell.self, forCellReuseIdentifier: EditRuleTableViewCell.className)
    rulesTableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func setEmptyView() {
    if editViewRules.isEmpty {
      ruleEmptyViewLabel.isHidden = false
      navigationBar.rightButton.isEnabled = false
    } else {
      ruleEmptyViewLabel.isHidden = true
      navigationBar.rightButton.isEnabled = true
    }
  }
  
  private func configUI() {
    navigationBar.updateRightButtonSnapKit()
    
    self.view.addSubViews([
      navigationBar,
      rulesTableView,
      ruleEmptyViewLabel
    ])
    
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }
    
    rulesTableView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    ruleEmptyViewLabel.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(48)
      make.centerX.equalToSuperview()
    }
    
    setEmptyView()
  }
  
  //MARK: - Bind
  private func bind() {
    let observable = Observable.just(self.editViewRules)
    
    observable
      .bind(to: rulesTableView.rx.items(cellIdentifier: EditRuleTableViewCell.className, cellType: EditRuleTableViewCell.self)) { [weak self] row, _, cell in
        guard let self = self else { return }
        
        let viewModel = self.editViewRules[row]
        
        cell.setTextFieldData(rule: viewModel.name)
        
        if row < 3 {
          cell.backgroundColor = Colors.blueL2.color
        } else {
          cell.backgroundColor = Colors.white.color
        }
        
        let existing = cell.backgroundColor
        
        cell.todoLabelTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
          .asDriver()
          .drive(onNext: { _ in
            
            let editBlueColor = Colors.blueEdit.color
            
            if cell.backgroundColor == existing {
              if row < 3 {
                cell.backgroundColor = editBlueColor
              } else {
                cell.backgroundColor = Colors.g3.color
              }
              
            } else {
              cell.backgroundColor = existing
            }
          })
          .disposed(by: cell.disposeBag)
        
        self.viewDidTapped
          .asDriver(onErrorJustReturn: ())
          .drive(onNext: { _ in
            cell.todoLabelTextField.endEditing(true)
          })
          .disposed(by: cell.disposeBag)
        
        cell.todoLabelTextField.rx.text
          .distinctUntilChanged()
          .asObservable()
          .subscribe(onNext: { [weak self] str in
            guard let self = self else { return }
            let changedName = str.map { $0 }
            
            let ruleWithIdViewModel = RuleWithIdViewModel(id: viewModel.id, name: changedName ?? "")
            
            self.editViewRules[row] = ruleWithIdViewModel
            
          })
          .disposed(by: cell.disposeBag)
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    
    rulesTableView.rx.itemMoved
      .map { $0 }
      .subscribe (onNext: { [weak self] event in
        guard let self = self else { return }
        self.editViewRules.swapAt(event.sourceIndex.row, event.destinationIndex.row)
        self.rulesTableView.reloadData()
      })
      .disposed(by: disposeBag)
    
    view.rx
      .tapGesture()
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.viewDidTapped.onNext(())
      })
      .disposed(by: disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .skip(1)
      .drive(onNext: { [weak self] height in
        guard let self = self else { return }
        
        let firstWindow = UIApplication.shared.connectedScenes
          .filter { $0.activationState == .foregroundActive }
          .map { $0 as? UIWindowScene }
          .compactMap { $0 }
          .first?.windows
          .filter { $0.isKeyWindow }
          .first
        
        let extra = firstWindow!.safeAreaInsets.bottom
        self.rulesTableView.snp.updateConstraints { make in
          make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(height - extra)
        }
      })
      .disposed(by: disposeBag)
    
    let input = EditRuleViewModel.Input(
      backButtonDidTap: navigationBar.backButton.rx.tap.asObservable(),
      saveButtonDidTap: saveButtonDidTapped
    )
    
    let output = viewModel.transform(input: input)
    
//    output.isEmptyView
//      .debug("EMPTY VIEW ! ")
//      .drive(onNext: { [weak self] flag in
//        guard let self = self else { return }
//        print("flag : ", flag, "✅✅✅✅✅")
//        self.ruleEmptyViewLabel.isHidden = !flag
//      })
//      .disposed(by: disposeBag)
    
    output.saveCompleted
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    output.moveToRuleMainView
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        let defaultPopUpModel = DefaultPopUpModel(
          cancelText: "계속 수정하기",
          actionText: "나가기",
          title: "수정사항이 저장되지 않았어요!",
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
    
  }

  private func upTableView() {

  }
  
  private func configButtonAction() {
    navigationBar.rightButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.saveButtonDidTapped.onNext(self.editViewRules)
      })
      .disposed(by: disposeBag)
  }
}

// Hiding Delete Button in TableView edit mode
extension EditRuleViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }

  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
      return false
  }
}
