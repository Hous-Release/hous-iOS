//
//  EditRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import RxKeyboard
import Network

class EditRuleViewController: UIViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "Rules 수정")
    navBar.setRightButtonText(text: "저장")
    return navBar
  }()
  
  private let rulesTableView = UITableView().then {
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
  
  private var editViewRules: [SectionOfRules]
  
  private let viewModel: EditRuleViewModel
  
  private var tabBarHeight: CGFloat = 83
  
  private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfRules>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
    
    switch item {
    case .editRule(let viewModel):
      return self.configEditRulesCell(viewModel: viewModel, atIndex: indexPath)
    default:
      return UITableViewCell()
    }
  }
  
  private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfRules>(configureCell: configureCell)
  
  
  init(editViewRules: [SectionOfRules], viewModel: EditRuleViewModel) {
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
      make.bottom.equalTo(self.view.snp.bottom).inset(tabBarHeight)
    }
    
    ruleEmptyViewLabel.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(48)
      make.centerX.equalToSuperview()
    }
  }
  
  //MARK: - Bind
  private func bind() {
    let observable = Observable.just(self.editViewRules)
    
    observable
      .bind(to: rulesTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    rulesTableView.rx.itemMoved
      .map { $0 }
      .subscribe (onNext: { [weak self] event in
        guard let self = self else { return }
        self.editViewRules[0].items.swapAt(event.sourceIndex.row, event.destinationIndex.row)
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
      .drive(onNext: { [weak self] height in
        guard let self = self else { return }
        // Keyboard 가 사라지면 height = 임 그렇기 때문에 당연히 맨마지막 아이템이 안보이는 것.
        let inset = height == 0.0 ? self.tabBarHeight : height
        self.rulesTableView.snp.updateConstraints { make in
          make.bottom.equalTo(self.view.snp.bottom).inset(inset)
        }
      })
      .disposed(by: disposeBag)
    
    let input = EditRuleViewModel.Input(
      backButtonDidTap: navigationBar.backButton.rx.tap.asObservable(),
      saveButtonDidTap: saveButtonDidTapped
    )
    
    let output = viewModel.transform(input: input)
    
    output.isEmptyView
      .drive(onNext: { [weak self] flag in
        guard let self = self else { return }
        self.ruleEmptyViewLabel.isHidden = !flag
      })
      .disposed(by: disposeBag)
    
    output.saveCompleted
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    output.moveToRuleMainView
      .drive(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
  }

  private func upTableView() {

  }
  
  private func configButtonAction() {
    navigationBar.rightButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        
        guard let self = self else { return }

        let editViewList = self.editViewRules.flatMap { model -> [RuleWithIdViewModel] in
          var ruleWithIds: [RuleWithIdViewModel] = []
          
          _ = model.items.map { item in
            switch item {
            case .editRule(let viewModel):
              ruleWithIds.append(RuleWithIdViewModel(id: viewModel.id, name: viewModel.name))
            default:
              break
            }
          }
          
          return ruleWithIds
        }

        
        self.saveButtonDidTapped.onNext(editViewList)
      })
      .disposed(by: disposeBag)
  }
}

extension EditRuleViewController {
  func configEditRulesCell(viewModel: RuleWithIdViewModel, atIndex: IndexPath) -> UITableViewCell {
    
    var viewModel = viewModel
    let item = self.editViewRules[0].items[atIndex.row]
    switch item {
    case .editRule(let vm):
      viewModel = vm
    default:
      break
    }
    
    
    guard let cell = self.rulesTableView.dequeueReusableCell(withIdentifier: EditRuleTableViewCell.className, for: atIndex) as? EditRuleTableViewCell else {
      return UITableViewCell()
    }
    cell.setTextFieldData(rule: viewModel.name)
    
    if atIndex.row < 3 {
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
          cell.backgroundColor = editBlueColor
        } else {
          cell.backgroundColor = existing
        }
      })
      .disposed(by: cell.disposeBag)
    
    viewDidTapped
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { _ in
        cell.todoLabelTextField.endEditing(true)
      })
      .disposed(by: cell.disposeBag)
    
    cell.todoLabelTextField.rx.text
      .distinctUntilChanged()
      .debug("text✨")
      .asObservable()
      .subscribe(onNext: { [weak self] str in
        guard let self = self else { return }
        let changedName = str.map { $0 }
        
        let ruleWithIdViewModel = RuleWithIdViewModel(id: viewModel.id, name: changedName ?? "")
        
        self.editViewRules[0].items[atIndex.row] = TableViewItem.editRule(viewModel: ruleWithIdViewModel)
        
      })
      .disposed(by: cell.disposeBag)
    
    cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    cell.selectionStyle = .none
    return cell
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
