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
import BottomSheetKit

protocol MainHomeViewControllerDelegate: AnyObject {
  func editHousName(initname: String)
}

class MainHomeViewController: BaseViewController, LoadingPresentable {

  private enum MainHomeSection: Int {
    case todos
    case ourRules
    case homiesProfiles
  }

  // MARK: - Vars & Lets
  private let viewModel: MainHomeViewModel
  private let disposeBag = DisposeBag()
  var delegate: MainHomeViewControllerDelegate?

  private let editButtonClicked = PublishRelay<Void>()
  private let copyButtonClicked = PublishRelay<Void>()
  private let viewWillAppear = PublishRelay<Void>()

  let todoBackgroundViewDidTap = PublishSubject<Void>()
  let welcomePopUpSubject = PublishSubject<String>()
  let shareCodeSubject = PublishSubject<String>()

  // MARK: - UI Components
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
  }

  // MARK: - Life Cycles
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setTabBarIsHidden(isHidden: false)
  }

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

  // MARK: Configurations
  private func configUI() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.isHidden = true
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
          if dto.color == "GRAY" {
            Toast.show(message: "아직 성향 테스트를 하지 않은 호미예요!", controller: self)
            break
          }
          let destinationViewController = MateProfileViewController(id: String(dto.homieID))
          self.navigationController?.pushViewController(destinationViewController, animated: true)
        default: break
        }
      })
      .disposed(by: disposeBag)

    // Cells
    collectionView.register(
      MainHomeTodoCollectionViewCell.self,
      forCellWithReuseIdentifier: MainHomeTodoCollectionViewCell.className
    )
    collectionView.register(
      MainHomeRulesCollectionViewCell.self,
      forCellWithReuseIdentifier: MainHomeRulesCollectionViewCell.className
    )
    collectionView.register(
      MainHomeProfileCollectionViewCell.self,
      forCellWithReuseIdentifier: MainHomeProfileCollectionViewCell.className
    )

    // Header & Footer
    collectionView.register(
      HomeHeaderCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeHeaderCollectionReusableView.className
    )
    collectionView.register(
      SeperatorLineCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: SeperatorLineCollectionReusableView.className
    )
  }

  private func configureCollectionViewCell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    item: MainHomeSectionModel.Item
  ) -> UICollectionViewCell {
    switch item {

    case .homieProfiles(profiles: let profiles):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MainHomeProfileCollectionViewCell.className,
        for: indexPath) as? MainHomeProfileCollectionViewCell else {
        return UICollectionViewCell()
      }

      cell.setProfileCell(homieColor: profiles.color, userNickname: profiles.userNickname)
      return cell
    case .ourTodos(todos: let todos):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MainHomeRulesCollectionViewCell.className,
        for: indexPath) as? MainHomeRulesCollectionViewCell else {
        return UICollectionViewCell()
      }

      Observable.merge(
        cell.ourRulesBackgroundView.rx.tapGesture()
          .when(.recognized)
          .map { _ in }
          .asObservable(),
        cell.ourRulesArrowButton.rx.tap.asObservable()
      )
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        let viewController = OurRulesViewController(viewModel: RulesViewModel())
        viewController.view.backgroundColor = .white
        self.navigationController?.pushViewController(viewController, animated: true)
      })
      .disposed(by: cell.disposeBag)

      cell.setHomeRulesCell(ourRules: todos.ourRules)

      return cell
    case .myTodos(todos: let todos):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MainHomeTodoCollectionViewCell.className,
        for: indexPath) as? MainHomeTodoCollectionViewCell else {
        return UICollectionViewCell()
      }

      cell.myTodoBackgroundView.rx.tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
          self.todoBackgroundViewDidTap.onNext(())
        })
        .disposed(by: cell.disposeBag)

      cell.editButton.rx.tap.asDriver()
        .drive(onNext: { [weak self] in
//          self?.delegate?.editHousName(initname: todos.roomName)
           self?.navigationController?.pushViewController(
                     EditHousNameViewController(roomName: todos.roomName),
            animated: true
           )
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
        progress: todos.progress,
        myTodos: todos.myTodos,
        myTodosTotalCount: todos.myTodosCnt
      )

      cell.setDailyLottie(day: Weekend(rawValue: todos.dayOfWeek) ?? .sat)

      cell.playLottie()

      return cell
    }
  }

  // MARK: Helpers
  private func bind() {
    let viewWillAppear =
    rx.rxViewWillAppear
      .asSignal()
      .do(onNext: { [weak self] _ in
        self?.showLoading()
      })

    let input = MainHomeViewModel.Input(
      viewWillAppear: viewWillAppear,
      copyButtonDidTapped: copyButtonClicked
    )

    let output = viewModel.transform(input: input)

    let dataSource =
    RxCollectionViewSectionedReloadDataSource<MainHomeSectionModel.Model> {
      [weak self] _, collectionView, indexPath, item in
      guard let self = self else { return UICollectionViewCell() }
      return self.configureCollectionViewCell(
        collectionView: collectionView,
        indexPath: indexPath,
        item: item
      )
    }

    dataSource.configureSupplementaryView = { (_, collectionView, kind, indexPath) -> UICollectionReusableView in
      switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: HomeHeaderCollectionReusableView.className,
                  for: indexPath) as? HomeHeaderCollectionReusableView
        else { return UICollectionReusableView() }

        if indexPath.section == MainHomeSection.homiesProfiles.rawValue {
          header.setSubTitleLabel(string: "Homies")
        }

        return header
      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: SeperatorLineCollectionReusableView.className,
          for: indexPath) as? SeperatorLineCollectionReusableView
        else { return UICollectionReusableView() }

        return footer
      default:
        return UICollectionReusableView()
      }
    }

    output.sections
      .do(onNext: { [weak self] _ in
        self?.hideLoading() })
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    output.roomCode
      .drive(onNext: { str in
        UIPasteboard.general.string = str
        Toast.show(message: "초대코드가 복사되었습니다", controller: self)
      })
      .disposed(by: disposeBag)

    welcomePopUpSubject
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] roomCode in
        guard let self = self else { return }
        let copyCodePopUpModel = ImagePopUpModel(image: .welcome, actionText: "호미들 바로 초대하기",
                                                    text:
    """
    방 생성이 완료 되었습니다.
    참여 코드를 복사해서
    룸메이트에게 공유해보세요!
    """)

        let popUpType = PopUpType.copyCode(copyPopUpModel: copyCodePopUpModel)

        self.presentPopUp(popUpType) { [weak self] actionType in
          guard let self = self else { return }
          switch actionType {
          case .action:
            self.dismiss(animated: true) {
              self.shareCodeSubject.onNext(roomCode)
            }
          case .cancel:
            break
          }
        }

      })
      .disposed(by: disposeBag)

    shareCodeSubject
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] roomCode in
        guard let self = self else { return }

        let textToShare: String = roomCode

        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.assignToContact]
        self.present(activityViewController, animated: true)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - CollectionView UICollectionViewDelegateFlowLayout

extension MainHomeViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    if section == MainHomeSection.homiesProfiles.rawValue {
      return CGSize(width: view.frame.size.width, height: 50)
    }

    return .zero
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
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

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    switch indexPath.section {
    case MainHomeSection.todos.rawValue:

      let width = view.window?.windowScene?.screen.bounds.width ?? 0
      let estimatedHeight: CGFloat = 300
      let dummyCell = MainHomeTodoCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))

      dummyCell.layoutIfNeeded()
      let estimatedSize = dummyCell.systemLayoutSizeFitting(
        CGSize(width: width, height: estimatedHeight)
      )
      return CGSize(width: width, height: estimatedSize.height)

    case MainHomeSection.ourRules.rawValue:
      return CGSize(width: UIScreen.main.bounds.width, height: 200)
    case MainHomeSection.homiesProfiles.rawValue:
      let width = UIScreen.main.bounds.width / 2 - 35
      let height = width * (100/155)

      return CGSize(width: width, height: height)
    default:
      return .zero
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {

    if section == MainHomeSection.homiesProfiles.rawValue { return 12 }
    return 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    if section == MainHomeSection.homiesProfiles.rawValue { return 17 }
    return 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    if section == MainHomeSection.homiesProfiles.rawValue {
      return UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
    }
    return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
  }
}

enum MainHomeSection: Int {
  case todos
  case ourRules
  case homiesProfiles
}

enum Weekend: String {
  case mon = "MONDAY"
  case tue = "TUESDAY"
  case wed = "WEDNESDAY"
  case thur = "THURSDAY"
  case fri = "FRIDAY"
  case sat = "SATURDAY"
  case sun = "SUNDAY"
}
