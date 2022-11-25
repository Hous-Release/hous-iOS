//
//  UpdateTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import AssetKit
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

final class UpdateTodoViewController: UIViewController, View {

  typealias Reactor = UpdateTodoReactor

  private typealias SECTION = UpdateTodoDataSource.Section
  private typealias ITEM = UpdateTodoDataSource.Item
  private typealias DataSource = UICollectionViewDiffableDataSource<SECTION, ITEM>
  private typealias SnapShot = NSDiffableDataSourceSnapshot<SECTION, ITEM>
  private typealias CellRegistration = UICollectionView.CellRegistration
  private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
  private typealias SectionSnapShot = NSDiffableDataSourceSectionSnapshot<ITEM>

  private struct Constants {
    static let verticalMargin: CGFloat = 16
    static let horizontalMargin: CGFloat = 24
    static let buttonHeight: CGFloat = 44
  }

  private lazy var navigationBar = NavBarWithBackButtonView(title: "")
  private var collectionView: UICollectionView!
  private var todoTextField: HousTextField!

  private var actionButton: UIButton!


  internal var disposeBag: DisposeBag = DisposeBag()
  private var dataSource: DataSource! = nil
  private var allSnapShot = SnapShot()
  private var assigneeSectionSnapShot = SectionSnapShot()
  private var individualSectionSnapShot = SectionSnapShot()

  // MARK: Cell Action Relay

  private let tapIndividual = PublishRelay<(_ : IndexPath)>()
  private let tapDay = PublishRelay<([UpdateTodoHomieModel.Day], id: Int)>()

  init(
    _ reactor: Reactor
  ) {
    super.init(nibName: nil, bundle: nil)
    setupView()
    setupLayout()
    configureDataSource()
    applyInitialSnapshots()

    self.reactor = reactor

  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
  }

}

  // MARK: - Action Bind
extension UpdateTodoViewController {
  func bindAction(_ reactor: Reactor) {
    bindViewWillAppearAction(reactor)
    bindDidEnterTodoAciton(reactor)
    bindTapIndividualAction(reactor)
    bindTapDayAction(reactor)
    bindTapUpdateAction(reactor)
    bindTapAlarmAction(reactor)
    bindReturnKeyAction()
  }

  func bindViewWillAppearAction(_ reactor: Reactor) {
    rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in Reactor.Action.fetch }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  func bindDidEnterTodoAciton(_ reactor: Reactor) {
    todoTextField.rx.text
      .map { Reactor.Action.enterTodo($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindTapIndividualAction(_ reactor: Reactor) {
    tapIndividual
      .map { Reactor.Action.didTapHomie($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  func bindTapDayAction(_ reactor: Reactor) {
    tapDay
      .map { Reactor.Action.didTapDays($0.0, id: $0.id) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  func bindTapUpdateAction(_ reactor: Reactor) {
    actionButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .asDriver(onErrorJustReturn: Void())
      .drive(onNext: self.tappedUpdate)
      .disposed(by: disposeBag)
  }
  func bindTapAlarmAction(_ reactor: Reactor) {
    navigationBar.rightButton.rx.tap
      .map { _ in Reactor.Action.didTapAlarm }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  func bindReturnKeyAction() {
    todoTextField.rx.controlEvent(.editingDidEndOnExit)
      .map { _ in true }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] endEditing in
        self?.view.endEditing(endEditing)
      })
      .disposed(by: disposeBag)
  }
}

  // MARK: - State Bind
extension UpdateTodoViewController {
  func bindState(_ reactor: Reactor) {
    bindPushNotificationState(reactor)
    bindTodoState(reactor)
    bindHomiesState(reactor)
    bindDidTapIndividualState(reactor)
    bindDidTapDayState(reactor)
    bindBackState(reactor)
    bindErrorState(reactor)
  }

  func bindPushNotificationState(_ reactor: Reactor) {
    reactor.state.map(\.isPushNotification)
      .distinctUntilChanged()
    // TODO: - bind로 유아이 바꾸기
      .bind(to: navigationBar.rightButton.rx.isSelected)
      .disposed(by: disposeBag)
  }
  func bindTodoState(_ reactor: Reactor) {
    reactor.state.map(\.todo)
      .distinctUntilChanged()
      .bind(to: self.todoTextField.rx.text)
      .disposed(by: disposeBag)
  }
  func bindHomiesState(_ reactor: Reactor) {
    reactor.state.map(\.todoHomies)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: self.applySnapShot)
      .disposed(by: disposeBag)
  }
  func bindDidTapIndividualState(_ reactor: Reactor) {
    reactor.pulse(\.$didTappedIndividual)
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: self.tappedIndividualCell)
      .disposed(by: disposeBag)
  }
  func bindDidTapDayState(_ reactor: Reactor) {
    reactor.pulse(\.$didTappedDay)
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: self.tappedDayCell)
      .disposed(by: disposeBag)
  }
  func bindBackState(_ reactor: Reactor) {
    reactor.pulse(\.$isBack)
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: self.back)
      .disposed(by: disposeBag)
  }
  func bindErrorState(_ reactor: Reactor) {
    reactor.pulse(\.$errorMessage)
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: self.showErrorToast)
      .disposed(by: disposeBag)
  }
}

extension UpdateTodoViewController {

  private func showErrorToast(_ errorMessage: String?) {
    guard let errorMessage = errorMessage else {
      return
    }
    Toast.show(message: errorMessage, controller: self)
  }

  private func back(_ backFlag: Bool) {
    if backFlag {
      navigationController?.popViewController(animated: true)
    }
  }

  private func tappedUpdate() {
    self.reactor?.action.onNext(.didTapUpdate)
  }

  private func tappedDayCell(_ tuple: (days: [UpdateTodoHomieModel.Day], id: Int)?) {

    guard let tuple = tuple else {
      return
    }
    let updateItems = individualSectionSnapShot.items
      .filter { $0.hasChild }
      .compactMap { item -> UpdateTodoHomieModel? in
        if item.homie?.onboardingID == tuple.id {

          var newHomie = item.homie
          newHomie?.selectedDay = tuple.days
          return newHomie
        }

        else {
          return item.homie
        }
      }
    DispatchQueue.main.async { [weak self] in
      self?.reactor?.action.onNext(Reactor.Action.updateHomie(updateItems))
    }
  }

  private func tappedIndividualCell(_ indexPath: IndexPath?) {
    guard
      let indexPath = indexPath,
      let item = self.dataSource.itemIdentifier(for: indexPath)
    else {
      return
    }
    var homie = item.homie
    homie?.isExpanded.toggle()
    let newItem = ITEM(homie: homie, hasChild: true)

    individualSectionSnapShot.insert([newItem], after: item)
    individualSectionSnapShot.delete([item])

    let updateItems = individualSectionSnapShot.items
      .filter{ $0.hasChild }
      .compactMap { $0.homie }


    DispatchQueue.main.async { [weak self] in
      self?.reactor?.action.onNext(Reactor.Action.updateHomie(updateItems))
    }
  }

  private func setupLayout() {
    view.addSubView(navigationBar)
    view.addSubView(todoTextField)
    view.addSubView(actionButton)
    view.addSubView(collectionView)

    navigationBar.snp.makeConstraints { make in
      make.height.equalTo(64)
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }
    todoTextField.snp.makeConstraints { make in
      make.height.equalTo(22)
      make.leading.trailing.equalToSuperview().inset(24)
      make.top.equalTo(navigationBar.snp.bottom).offset(32)
    }

    actionButton.snp.makeConstraints { make in
      make.height.equalTo(Constants.buttonHeight)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.verticalMargin)
      make.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(todoTextField.snp.bottom).offset(46)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(actionButton.snp.top).offset(-Constants.verticalMargin / 2)
    }
  }

  private func setupNavigationBar() {
    guard let reactor = reactor else {
      return
    }

    let navTitle = reactor.initialState.isModifying ?
    "to-do 수정"
    :
    "새로운 to-do 추가"

    let buttonTilte = reactor.initialState.isModifying ?
    "저장하기"
    :
    "추가하기"

    navigationBar.rightButton.setImage(Images.icAlarmoff.image, for: .normal)
    navigationBar.rightButton.setImage(Images.icAlarmon.image, for: .selected)
    navigationBar.rightButton.backgroundColor = Colors.white.color
    navigationBar.title = navTitle
    actionButton.setTitle(buttonTilte, for: .normal)
  }

  private func setupView() {

    view.backgroundColor = Colors.white.color
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.backgroundColor = Colors.white.color
    collectionView.delegate = self

    // TODO: - 경고문구가 뭔지 모르겠어요
    todoTextField = HousTextField(
      "Todo 입력",
      useMaxCount: true,
      maxCount: 15,
      exceedString: "어쩔티비"
    )
    todoTextField.returnKeyType = .done

    actionButton = UIButton()
    actionButton.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    actionButton.setTitleColor(Colors.white.color, for: .normal)
    actionButton.backgroundColor = Colors.blue.color
    actionButton.layer.cornerRadius = 5
  }

  /// - Tag: CreateFullLayout
  private func createLayout() -> UICollectionViewLayout {

    let sectionProvider = { [weak self] (
      sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? in

      guard
        let self = self,
        let sectionKind = SECTION(rawValue: sectionIndex)
      else {
        return nil
      }

      let section: NSCollectionLayoutSection

      switch sectionKind {
      case .assignee:
        section = self.createSection()

      case .individual:

        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        section = NSCollectionLayoutSection.list(
          using: configuration,
          layoutEnvironment: layoutEnvironment
        )

        section.contentInsets = NSDirectionalEdgeInsets(
          top: 0,
          leading: 0,
          bottom: 0,
          trailing: 0
        )
      }

      return section
    }

    return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
  }

  private func createSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(1),
      heightDimension: .estimated(1)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: .fixed(4),
      top: nil,
      trailing: .fixed(4),
      bottom: nil
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(1)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )

    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: nil,
      top: .fixed(2),
      trailing: nil,
      bottom: .fixed(2)
    )

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: Constants.verticalMargin / 2,
      leading: Constants.horizontalMargin,
      bottom: Constants.verticalMargin,
      trailing: Constants.horizontalMargin
    )

    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }

  private func createHeaderRegistration() -> SupplementaryRegistration<TitleSupplementaryView> {

    return SupplementaryRegistration<TitleSupplementaryView>(
      elementKind: UICollectionView.elementKindSectionHeader
    ) { supplementaryView, elementKind, indexPath in
      supplementaryView.label.text = "담당자"
    }
  }

  private func createAssigneeRegistration() -> CellRegistration<AssigneeCell, ITEM> {
    return CellRegistration<AssigneeCell, ITEM> { (cell, indexPath, item) in
      guard
        let item = item.homie
      else {
        return
      }
      cell.configure(item)
    }
  }

  private func createIndividualRegistration() -> CellRegistration<IndividualCell, ITEM> {
    return CellRegistration<IndividualCell, ITEM> { (cell, indexPath, item) in
      guard
        let item = item.homie
      else {
        return
      }
      cell.configure(item)
    }
  }
  private func createDayRegistration() -> CellRegistration<DayCell, ITEM> {
    return CellRegistration<DayCell, ITEM> { (cell, indexPath, item) in
      guard
        let item = item.homie
      else {
        return
      }
      cell.configure(item)
      cell.delegate = self
    }
  }

  private func configureDataSource() {

    let assigneeCellRegistration = createAssigneeRegistration()
    let individualRegistration = createIndividualRegistration()
    let dayRegistration = createDayRegistration()
    let headerRegistration = createHeaderRegistration()

    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewCell? in

      guard
        let section = SECTION(rawValue: indexPath.section)
      else {
        fatalError("Unknown section")
      }
      switch section {

      case .assignee:
        return collectionView.dequeueConfiguredReusableCell(
          using: assigneeCellRegistration,
          for: indexPath,
          item: item
        )

      case .individual:

        if item.hasChild {
          return collectionView.dequeueConfiguredReusableCell(
            using: individualRegistration,
            for: indexPath,
            item: item
          )
        }
        else {
          return collectionView.dequeueConfiguredReusableCell(
            using: dayRegistration,
            for: indexPath,
            item: item
          )
        }
      }
    }
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return self.collectionView.dequeueConfiguredReusableSupplementary(
        using: headerRegistration,
        for: index
      )
    }
  }

  private func applySnapShot(_ homies: [UpdateTodoHomieModel]) {
    applyAssigneeSnapShot(homies)
    applyIndividualSnapShot(homies)
  }

  private func applyAssigneeSnapShot(_ homies: [UpdateTodoHomieModel]) {
    var snapShot = NSDiffableDataSourceSectionSnapshot<ITEM>()

    let selectedHomies = homies.filter { !$0.selectedDay.isEmpty }

    let items = selectedHomies.map {
      ITEM.init(homie: $0, hasChild: false)
    }
    snapShot.append(items)
    self.assigneeSectionSnapShot = snapShot
    dataSource.apply(snapShot, to: .assignee, animatingDifferences: false)
  }

  private func applyIndividualSnapShot(_ homies: [UpdateTodoHomieModel]) {
    var snapShot = NSDiffableDataSourceSectionSnapshot<ITEM>()

    for homie in homies {
      let rootItem = ITEM(homie: homie, hasChild: true)
      snapShot.append([rootItem])

      let childItem = ITEM(homie: homie, hasChild: false)
      snapShot.append([childItem], to: rootItem)

      homie.isExpanded ?
      snapShot.expand([rootItem])
      :
      snapShot.collapse([rootItem])

      self.individualSectionSnapShot = snapShot
    }
    dataSource.apply(snapShot, to: .individual, animatingDifferences: true)
  }

  private func applyInitialSnapshots() {
    let sections = SECTION.allCases
    var snapshot = SnapShot()
    snapshot.appendSections(sections)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension UpdateTodoViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let item = self.dataSource.itemIdentifier(for: indexPath)
    else {
      return
    }
    if item.hasChild {
      tapIndividual.accept(indexPath)
    }
  }
}
// MARK: Cell Delegate

extension UpdateTodoViewController: DidTapDayDelegate {
  func didTapDay(days: [UpdateTodoHomieModel.Day], to id: Int) {
    tapDay.accept((days, id))
  }
}
