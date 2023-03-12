//
//  ProfileViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/07.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileViewController: BaseViewController {

  // MARK: RX Components

  let disposeBag = DisposeBag()
  var viewModel = ProfileViewModel()
  var isEmptyView = true
  var data = ProfileModel()

  // MARK: UI Templetes

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let profileMainImageCellHeight = CGSize(width: Size.screenWidth, height: 254)
    static let profileInfoCellHeight = CGSize(width: Size.screenWidth, height: 176)
    static let profileGraphCellHeight = CGSize(width: Size.screenWidth, height: 283)
    static let profileAttributeInfoCellHeight = CGSize(width: Size.screenWidth, height: 180)
    static let profileRetryCellHeight = CGSize(width: Size.screenWidth, height: 139)
    static let profileEmptyCellHeight = CGSize(width: Size.screenWidth, height: 325)
  }

  // MARK: UI Components

  private let profileCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: ProfileMainImageCollectionViewCell.self)
    collectionView.register(cell: ProfileInfoCollectionViewCell.self)
    collectionView.register(cell: ProfileGraphCollectionViewCell.self)
    collectionView.register(cell: ProfileDescriptionCollectionViewCell.self)
    collectionView.register(cell: ProfileRetryCollectionViewCell.self)
    collectionView.register(cell: ProfileEmptyCollectionViewCell.self)
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()

  // MARK: Life Cycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: false)
    profileCollectionView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    render()
  }

  // MARK: Setup UI

  private func setup() {
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    profileCollectionView.backgroundColor = .white
    profileCollectionView.delegate = self
    navigationController?.navigationBar.isHidden = true
  }

  // MARK: Bind

  private func bind() {

    // input

    let viewWillAppear = rx.rxViewWillAppear
      .do(onNext: { [weak self] _ in
        self?.showLoading()
      })
      .map { _ in }
      .asSignal(onErrorJustReturn: ())

    let actionDetected = PublishSubject<ProfileActionControl>()

    let input = ProfileViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )

    // output

    let output = viewModel.transform(input: input)

    var countCell: Int = 0

    output.profileModel
      .do {
        self.hideLoading()
        self.data = $0
        self.isEmptyView = $0.isEmptyView
        countCell = $0.isEmptyView ? 3 : 5}
      .map {
        [ProfileModel](repeating: $0, count: countCell)
      }
      .bind(to: profileCollectionView.rx.items) {
        (_: UICollectionView, index: Int, element: ProfileModel) in
        let indexPath = IndexPath(row: index, section: 0)
        switch indexPath.row {
        case 0:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileMainImageCollectionViewCell.className,
                    for: indexPath) as? ProfileMainImageCollectionViewCell
          else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          cell.cellActionControlSubject
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { data in
              actionDetected.onNext(data)
            })
            .disposed(by: cell.disposeBag)
          return cell
        case 1:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileInfoCollectionViewCell.className,
                    for: indexPath) as? ProfileInfoCollectionViewCell
          else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          cell.cellActionControlSubject
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { data in
              actionDetected.onNext(data)
            })
            .disposed(by: cell.disposeBag)
          return cell
        case 2:
          self.isEmptyView = element.isEmptyView
          if element.isEmptyView {
            guard let cell =
                    self.profileCollectionView.dequeueReusableCell(
                      withReuseIdentifier: ProfileEmptyCollectionViewCell.className,
                      for: indexPath) as? ProfileEmptyCollectionViewCell
            else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
            cell.bind(element)
            cell.cellActionControlSubject
              .asDriver(onErrorJustReturn: .none)
              .drive(onNext: { data in
                actionDetected.onNext(data)
              })
              .disposed(by: cell.disposeBag)
            return cell
          } else {
            guard let cell =
                    self.profileCollectionView.dequeueReusableCell(
                      withReuseIdentifier: ProfileGraphCollectionViewCell.className,
                      for: indexPath) as? ProfileGraphCollectionViewCell
            else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
            cell.bind(element)
            cell.cellActionControlSubject
              .asDriver(onErrorJustReturn: .none)
              .drive(onNext: { data in
                actionDetected.onNext(data)
              })
              .disposed(by: cell.disposeBag)
            return cell
          }

        case 3:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileDescriptionCollectionViewCell.className,
                    for: indexPath) as? ProfileDescriptionCollectionViewCell
          else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        case 4:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileRetryCollectionViewCell.className,
                    for: indexPath) as? ProfileRetryCollectionViewCell
          else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          cell.cellActionControlSubject
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { data in
              actionDetected.onNext(data)
            })
            .disposed(by: cell.disposeBag)
          return cell
        default:
          print("NO Cell")
          return UICollectionViewCell()
        }
      }
      .disposed(by: disposeBag)

    output.actionControl
      .subscribe(onNext: {[weak self] in self?.doNavigation(action: $0)})
      .disposed(by: disposeBag)

  }

  // MARK: Render

  private func render() {
    view.addSubview(profileCollectionView)
    profileCollectionView.snp.makeConstraints { make in
      make.top.bottom.trailing.leading.equalToSuperview()
    }
  }

  // MARK: Navigation

  private func doNavigation(action: ProfileActionControl) {
    switch action {
    case .didTabAlarm:
      let destinationViewController = ProfileAlarmViewController()
      destinationViewController.view.backgroundColor = .white
      navigationController?.pushViewController(destinationViewController, animated: true)
    case .didTabSetting:
      let destinationViewController = ProfileSettingViewController(isInRoom: true)
      destinationViewController.view.backgroundColor = .white
      navigationController?.pushViewController(destinationViewController, animated: true)
    case .didTabEdit:
      let destinationViewController = ProfileEditViewController(data: self.data)
      destinationViewController.view.backgroundColor = .white
      navigationController?.pushViewController(destinationViewController, animated: true)
    case .didTabDetail:
      let destinationViewController = ProfileDetailViewController(color: self.data.personalityColor,
                                                                  isFromTypeTest: false)
      destinationViewController.view.backgroundColor = .white
      navigationController?.pushViewController(destinationViewController, animated: true)
    case .didTabBadge:
      let badgeViewModel = BadgeViewModel()
      let destinationViewController = BadgeViewController(viewModel: badgeViewModel)
      destinationViewController.view.backgroundColor = .white
      navigationController?.pushViewController(destinationViewController, animated: true)
    case .didTabTest:
      let destinationViewController = ProfileTestInfoViewController()
      destinationViewController.view.backgroundColor = .white
      navigationController?.pushViewController(destinationViewController, animated: true)
    default:
      return
    }
  }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch indexPath.row {
    case 0:
      return Size.profileMainImageCellHeight
    case 1:
      return Size.profileInfoCellHeight
    case 2:
      if self.isEmptyView {
        return Size.profileEmptyCellHeight
      } else {
        return Size.profileGraphCellHeight
      }
    case 3:
      return Size.profileAttributeInfoCellHeight
    case 4:
      return Size.profileRetryCellHeight
    default:
      return CGSize(width: 0, height: 0)
    }
  }
}
