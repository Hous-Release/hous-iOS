//
//  BadgeViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture


class BadgeViewController: LoadingBaseViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "내 배지")
    navBar.backgroundColor = Colors.g7.color
    navBar.setBackButtonColor(color: Colors.white.color)
    navBar.setTitleLabelTextColor(color: Colors.white.color)
    return navBar
  }()
  
  private let badgeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
    $0.contentInsetAdjustmentBehavior = .never
    $0.showsVerticalScrollIndicator = false
  }
  
  private lazy var configureCell: RxCollectionViewSectionedReloadDataSource<SectionOfProfile>.ConfigureCell = { [unowned self] (dataSource, cv, indexPath, item) -> UICollectionViewCell in
    
    switch item {
    case .representingBadge(let representViewModel):
      return self.configRepresentingBadgeCell(viewModel: representViewModel, indexPath: indexPath)
    case .badges(let roomBadgeViewModel):
      return self.configBadgesCell(viewModel: roomBadgeViewModel, indexPath: indexPath)
    }
    
  }
  
  private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfProfile>(configureCell: configureCell)
  
  private let disposeBag = DisposeBag()
  
  private let viewModel: BadgeViewModel
  
  private let selectedMainBadgeSubject = PublishSubject<Int>()
  
  private let updatedRepresentBadgeCompleted = PublishSubject<Int>()
  
  private var badgeWithStateModel: [RoomBadgeViewModel] = []
  
  init(viewModel: BadgeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    setBadgeCollectionView()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.setTabBarIsHidden(isHidden: true)
  }
  
  private func setBadgeCollectionView() {
    badgeCollectionView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    
    badgeCollectionView.register(RepresentingBadgeCollectionViewCell.self, forCellWithReuseIdentifier: RepresentingBadgeCollectionViewCell.className)
    
    badgeCollectionView.register(BadgeCollectionViewCell.self, forCellWithReuseIdentifier: BadgeCollectionViewCell.className)
  }
  
  private func configUI() {
    view.addSubViews([
      badgeCollectionView,
      navigationBar
    ])
    
    configLoadingLayout()
    
    badgeCollectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }
  }
  
  private func bind() {
    let input = BadgeViewModel.Input(
      viewWillAppear: rx.RxViewWillAppear.asObservable()
        .do(onNext: { [weak self] _ in self?.showLoading() }),
      backButtonDidTapped: navigationBar.backButton.rx.tap.asObservable(),
      selectedMainBadge: selectedMainBadgeSubject
    )
    
    let output = viewModel.transform(input: input)
    
    output.sections
      .do(onNext: { [weak self] _ in self?.hideLoading() })
      .drive(badgeCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    output.badgesWithState
      .drive(onNext: { [weak self] models in
        guard let self = self else { return }
        self.badgeWithStateModel = models
      })
      .disposed(by: disposeBag)
    
    output.updatedRepresentBadge
      .drive(onNext: { [weak self] representbadgeId in
        guard let self = self else { return }
        self.updatedRepresentBadgeCompleted.onNext(representbadgeId)
      })
      .disposed(by: disposeBag)
    
    output.popViewController
      .drive(onNext: { [weak self] in
        self?.setTabBarIsHidden(isHidden: false)
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
  }
  
}

extension BadgeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if indexPath.section == 0 {
      return CGSize(width: view.window?.windowScene?.screen.bounds.width ?? 375, height: (view.window?.windowScene?.screen.bounds.width ?? 375) * (180 / (view.window?.windowScene?.screen.bounds.width ?? 375)))
    }
    return CGSize(width: 80, height: 152)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 28
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == 0 {
      return .zero
    }
    return UIEdgeInsets(top: 39, left: 32, bottom: 0, right: 32)
  }
}

extension BadgeViewController {
  
  func configRepresentingBadgeCell(
    viewModel: RepresentingBadgeViewModel,
    indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = self.badgeCollectionView.dequeueReusableCell(withReuseIdentifier: RepresentingBadgeCollectionViewCell.className, for: indexPath) as? RepresentingBadgeCollectionViewCell else { return UICollectionViewCell() }
      
      updatedRepresentBadgeCompleted
        .asDriver(onErrorJustReturn: -1)
        .drive(onNext: { [weak self] id in
          guard let self = self else { return }
          
          var idx = 0
          var before = 0
          self.badgeWithStateModel.enumerated().forEach { (index, model) in
            if model.id == id {
              idx = index
            } else if model.tapState == .representing {
              before = index
              self.badgeWithStateModel[index].tapState = .none
            }
          }
          let urlString = self.badgeWithStateModel[idx].imageURL
          let title = self.badgeWithStateModel[idx].title
          cell.setRepresntingBadgeCellData(viewModel: RepresentingBadgeViewModel(imageURL: urlString, title: title))
          
          let idPath = IndexPath(row: before, section: 1)
          self.badgeCollectionView.reloadItems(at: [idPath])
        })
        .disposed(by: cell.disposeBag)
      
    cell.setRepresntingBadgeCellData(viewModel: viewModel)
    
    return cell
  }
  
  func configBadgesCell(
    viewModel: RoomBadgeViewModel,
    indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = self.badgeCollectionView.dequeueReusableCell(withReuseIdentifier: BadgeCollectionViewCell.className, for: indexPath) as? BadgeCollectionViewCell else { return UICollectionViewCell() }
      
      cell.badgeImageView.rx.tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
          
          var idx = 0
          var before = 0
          self.badgeWithStateModel.enumerated().forEach { (index, model) in
            if model.id == viewModel.id {
              idx = index
            } else if model.tapState == .representing {
              return
            } else if model.tapState == .selected {
              before = index
              self.badgeWithStateModel[index].tapState = .none
            }
          }
          
          let state = self.badgeWithStateModel[idx].tapState
          
          switch state {
          case .none:
            self.badgeWithStateModel[idx].tapState = .selected
          case .selected:
            self.badgeWithStateModel[idx].tapState = .representing
            self.selectedMainBadgeSubject.onNext(viewModel.id)
          case .representing:
            return
          }
          
          cell.setRoomBadgeCellData(viewModel: self.badgeWithStateModel[idx])
          let idPath = IndexPath(row: before, section: 1)
          self.badgeCollectionView.reloadItems(at: [idPath])
        })
        .disposed(by: cell.disposeBag)
      
      if badgeWithStateModel.isEmpty {
        cell.setRoomBadgeCellData(viewModel: viewModel)
      } else {
        cell.setRoomBadgeCellData(viewModel: badgeWithStateModel[indexPath.row])
      }
      
      
      
    return cell
  }
}


