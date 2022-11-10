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


class BadgeViewController: UIViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "내 배지")
    navBar.backgroundColor = .clear
    navBar.setBackButtonColor(color: Colors.white.color)
    navBar.setTitleLabelTextColor(color: Colors.white.color)
    return navBar
  }()
  
  private let badgeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
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
  
  private func setBadgeCollectionView() {
    badgeCollectionView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    
    badgeCollectionView.register(RepresentingBadgeCollectionViewCell.self, forCellWithReuseIdentifier: RepresentingBadgeCollectionViewCell.className)
    
    badgeCollectionView.register(BadgeCollectionViewCell.self, forCellWithReuseIdentifier: BadgeCollectionViewCell.className)
  }
  
  private func configUI() {
    self.setTabBarIsHidden(isHidden: true)
    
    view.addSubViews([
      badgeCollectionView,
      navigationBar
    ])
    
    badgeCollectionView.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top)
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
      viewWillAppear: rx.RxViewWillAppear.asObservable(),
      backButtonDidTapped: navigationBar.backButton.rx.tap.asObservable(),
      selectedMainBadge: selectedMainBadgeSubject
    )
    
    let output = viewModel.transform(input: input)
    
    output.sections
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
  }
  
}

extension BadgeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if indexPath.section == 0 {
      return CGSize(width: view.window?.windowScene?.screen.bounds.width ?? 375, height: (view.window?.windowScene?.screen.bounds.height ?? 812) * (255/812))
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
    return UIEdgeInsets(top: 39, left: 24, bottom: 0, right: 24)
  }
}

extension BadgeViewController {
  
  func configRepresentingBadgeCell(
    viewModel: RepresentingBadgeViewModel,
    indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = self.badgeCollectionView.dequeueReusableCell(withReuseIdentifier: RepresentingBadgeCollectionViewCell.className, for: indexPath) as? RepresentingBadgeCollectionViewCell else { return UICollectionViewCell() }
      
      updatedRepresentBadgeCompleted
        .asDriver(onErrorJustReturn: -1)
        .drive(onNext: { id in
          var idx = 0
          self.badgeWithStateModel.enumerated().forEach { (index, model) in
            if model.id == id {
              idx = index
            }
          }
          let urlString = self.badgeWithStateModel[idx].imageURL
          let title = self.badgeWithStateModel[idx].title
          cell.setRepresntingBadgeCellData(viewModel: RepresentingBadgeViewModel(imageURL: urlString, title: title))
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
        .subscribe(onNext: { _ in
          var idx = 0
          self.badgeWithStateModel.enumerated().forEach { (index, model) in
            if model.id == viewModel.id {
              idx = index
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
            print("대표 최고 !! 👍")
          }
          
          cell.setTapStatusView(tapState: self.badgeWithStateModel[idx].tapState)
        })
        .disposed(by: cell.disposeBag)

      
      cell.setRoomBadgeCellData(viewModel: viewModel)
      
    return cell
  }
}
