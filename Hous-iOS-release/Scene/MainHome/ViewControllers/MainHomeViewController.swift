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
import RxGesture

class MainHomeViewController: UIViewController {
  
  private enum MainHomeSection: Int {
    case todos
    case ourRules
    case homiesProfiles
  }
  
  //MARK: - Vars & Lets
  private let viewModel: MainHomeViewModel
  private let disposeBag = DisposeBag()
  
  private let editButtonClicked = PublishRelay<Void>()
  private let copyButtonClicked = PublishRelay<Void>()
  private let viewWillAppear = PublishRelay<Void>()
    
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
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaInsets).inset(60)
    }
  }
  
  private func configCollectionView() {
    collectionView.delegate = self
    
    collectionView.rx.modelSelected(MainHomeSectionModel.Item.self)
      .subscribe(onNext: { model in
        
        switch model {
        case .homieProfiles(profiles: let dto):
          //TODO: Profile화면전환
          print(dto.userNickname)
        default: break
        }
      })
      .disposed(by: disposeBag)
    
    // Cells
    collectionView.register(MainHomeTodoCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeTodoCollectionViewCell.className)
    collectionView.register(MainHomeRulesCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeRulesCollectionViewCell.className)
    collectionView.register(MainHomeProfileCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeProfileCollectionViewCell.className)

    // Header & Footer
    collectionView.register(HomeHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.className)
    collectionView.register(SeperatorLineCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeperatorLineCollectionReusableView.className)
  }
  
  private func configureCollectionViewCell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    item: MainHomeSectionModel.Item
  ) -> UICollectionViewCell {
    switch item {
      
    case .homieProfiles(profiles: let profiles):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeProfileCollectionViewCell.className, for: indexPath) as? MainHomeProfileCollectionViewCell else {
        return UICollectionViewCell()
      }
      
      cell.setProfileCell(homieColor: profiles.color, userNickname: profiles.userNickname)
      return cell
    case .ourTodos(todos: let todos):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeRulesCollectionViewCell.className, for: indexPath) as? MainHomeRulesCollectionViewCell else { return UICollectionViewCell()
      }
      
      cell.ourRulesArrowButton.rx.tap
        .asDriver()
        .drive(onNext: { [weak self] in
          //TODO: Rules화면으로 화면전환
          guard let self = self else { return }
          let vc = TodoViewController()
          self.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: cell.disposeBag)
      
      cell.setHomeRulesCell(ourRules: todos.ourRules)

      return cell
    case .myTodos(todos: let todos):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeTodoCollectionViewCell.className, for: indexPath) as? MainHomeTodoCollectionViewCell else { return UICollectionViewCell()
      }
      
      cell.myTodoBackgroundView.rx.tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
          let vc = TodoViewController()
          self.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
      
      cell.editButton.rx.tap.asDriver()
        .drive(onNext: { [weak self] in
          self?.navigationController?.pushViewController(EditHousNameViewController(), animated: true)
        })
        .disposed(by: cell.disposeBag)

      cell.copyButton.rx.tap.asDriver()
        .drive(onNext: { [weak self] _ in
          guard let self = self else { return }
          self.copyButtonClicked.accept(())
        })
        .disposed(by: cell.disposeBag)
      
      cell.setHomeTodoCell(
        titleText: "\(todos.userNickname)님의,\n\(todos.roomName) 하우스",
        progress: Float(todos.progress / 100),
        myTodos: todos.myTodos
      )
      
      return cell
    }
  }

  //MARK: Helpers
  private func bind() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asSignal(onErrorJustReturn: ())
    
    let input = MainHomeViewModel.Input(
      viewWillAppear: viewWillAppear,
      copyButtonDidTapped: copyButtonClicked
    )

    let output = viewModel.transform(input: input)
    
    let dataSource =
    RxCollectionViewSectionedReloadDataSource<MainHomeSectionModel.Model> { [weak self] dataSource, collectionView, indexPath, item in
      guard let self = self else { return UICollectionViewCell() }
      return self.configureCollectionViewCell(
        collectionView: collectionView,
        indexPath: indexPath,
        item: item
      )
    }
    
    dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
      switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderCollectionReusableView.className, for: indexPath) as? HomeHeaderCollectionReusableView else { return UICollectionReusableView() }

        if indexPath.section == MainHomeSection.homiesProfiles.rawValue {
          header.setSubTitleLabel(string: "Homies")
        }

        return header
      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SeperatorLineCollectionReusableView.className, for: indexPath) as? SeperatorLineCollectionReusableView else { return UICollectionReusableView() }

        return footer
      default:
        return UICollectionReusableView()
      }
    }
    
    output.sections
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    output.roomCode
      .drive(onNext: { str in
        UIPasteboard.general.string = str
        if let _ = UIPasteboard.general.string {
          Toast.show(message: "초대코드가 복사되었습니다", controller: self)
        }
      })
      .disposed(by: disposeBag)
  }
}

// Edit홈에
extension MainHomeViewController {
  @objc private func didPopRoomNameEditView() {
    self.viewWillAppear.accept(())
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
      return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (305/812))
    case MainHomeSection.ourRules.rawValue:
      return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (246/812))
    case MainHomeSection.homiesProfiles.rawValue:
      let width = UIScreen.main.bounds.width / 2 - 35
      let height = width * (100/155)

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
