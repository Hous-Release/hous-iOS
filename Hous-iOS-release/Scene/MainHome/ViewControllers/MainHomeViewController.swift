//
//  HousViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/07.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import Network

class MainHomeViewController: UIViewController {
  
  private enum MainHomeSection: Int {
    case todos = 0
    case ourRules
    case homiesProfiles
  }
  
  //MARK: - Vars & Lets
  private let viewModel: MainHomeViewModel
  private let disposeBag = DisposeBag()
  
  //MARK: - UI Components
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical

    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
  }
  
  //MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    configCollectionView()
    bind()
  }
  
  init(viewModel: MainHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: Configurations
  private func configUI() {
    view.backgroundColor = .systemBackground
    navigationController?.isNavigationBarHidden = true
    view.addSubview(collectionView)
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configCollectionView() {
    collectionView.delegate = self
    // Cells
    collectionView.register(MainHomeTodoCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeTodoCollectionViewCell.identifier)
    collectionView.register(MainHomeRulesCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeRulesCollectionViewCell.identifier)
    collectionView.register(MainHomeProfileCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeProfileCollectionViewCell.identifier)

    // Header & Footer
    collectionView.register(HomeHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.identifier)
    collectionView.register(SeperatorLineCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeperatorLineCollectionReusableView.identifier)
  }
  
  private static func configureCollectionViewCell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    item: MainHomeSectionModel.Item
  ) -> UICollectionViewCell {
    switch item {
      
    case .homieProfiles(profiles: let profiles):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeProfileCollectionViewCell.identifier, for: indexPath) as? MainHomeProfileCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.setProfileCell(userNickname: profiles[indexPath.item].userNickname)
      return cell
    case .ourTodos(todos: let todos):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeRulesCollectionViewCell.identifier, for: indexPath) as? MainHomeRulesCollectionViewCell else { return UICollectionViewCell()
      }
      cell.setHomeRulesCell(ourRules: todos.ourRules)

      return cell
    case .myTodos(todos: let todos):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeTodoCollectionViewCell.identifier, for: indexPath) as? MainHomeTodoCollectionViewCell else { return UICollectionViewCell()
      }
      
      cell.setHomeTodoCell(
        titleText: "\(todos.userNickname)님의\n\(todos.roomName) 하우스",
        progress: Float(todos.progress / 100),
        myTodos: todos.myTodos
      )
      return cell
    }
  }

  //MARK: Helpers
  private func bind() {
    let input = MainHomeViewModel.Input(
      viewWillAppear: rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map{ _ in }.asSignal(onErrorJustReturn: ())
    )

    let output = viewModel.transform(input: input)
    
    let dataSource =
    RxCollectionViewSectionedReloadDataSource<MainHomeSectionModel.Model> { dataSource, collectionView, indexPath, item in
      Self.configureCollectionViewCell(
        collectionView: collectionView,
        indexPath: indexPath, item: item
      )
    }
    
    dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
      switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderCollectionReusableView.identifier, for: indexPath) as? HomeHeaderCollectionReusableView else { return UICollectionReusableView() }

        if indexPath.section == MainHomeSection.homiesProfiles.rawValue {
          header.setSubTitleLabel(string: "Homies")
        }

        return header
      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SeperatorLineCollectionReusableView.identifier, for: indexPath) as? SeperatorLineCollectionReusableView else { return UICollectionReusableView() }

        return footer
      default:
        assert(false, "Unexpected element kind")
      }
    }
    
    output.sections
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}




//MARK: - CollectionView UICollectionViewDelegateFlowLayout

extension MainHomeViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == MainHomeSection.homiesProfiles.rawValue {
      return CGSize(width: view.frame.size.width, height: 50)
    }

    return .zero
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    switch section {
    case MainHomeSection.todos.rawValue:
      return CGSize(width: UIScreen.main.bounds.width, height: 1)
    case MainHomeSection.ourRules.rawValue:
      return CGSize(width: UIScreen.main.bounds.width, height: 1)
    case MainHomeSection.homiesProfiles.rawValue:
      return .zero
    default:
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    switch indexPath.section {
    case MainHomeSection.todos.rawValue:
      return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (312/812))
    case MainHomeSection.ourRules.rawValue:
      return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (246/812))
    case MainHomeSection.homiesProfiles.rawValue:
      let width = UIScreen.main.bounds.width / 2 - 35
      let height = width * 0.6451612903

      return CGSize(width: width, height: height)
    default:
      return .zero
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

    if section == MainHomeSection.homiesProfiles.rawValue { return 12 }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    if section == MainHomeSection.homiesProfiles.rawValue { return 17 }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == MainHomeSection.homiesProfiles.rawValue {
      return UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
    }
    return UIEdgeInsets()
  }
}


extension MainHomeViewController: MainHomeTodoProtocol {
  
  func editButtonDidTapped() {
    let editVC = EditHousNameViewController()
    self.navigationController?.pushViewController(editVC, animated: true)
  }
  
  func copyButtonDidTapped() {
    print("copied")
  }
  
}
