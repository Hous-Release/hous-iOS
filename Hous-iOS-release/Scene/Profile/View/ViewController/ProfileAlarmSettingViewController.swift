//
//  ProfileAlarmSettingViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/09.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import HousUIComponent

final class ProfileAlarmSettingViewController: BaseViewController, LoadingPresentable {

  // MARK: RX Components

  private let disposeBag = DisposeBag()
  private let viewModel = ProfileAlarmSettingViewModel()
  private let temporarilySetCellSubject = PublishSubject<Void>()

  // MARK: UI Templetes

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let oneOptionCellSize = CGSize(width: Size.screenWidth, height: 67)
    static let twoOptionCellSize = CGSize(width: Size.screenWidth, height: 169)
    static let threeOptionCellSize = CGSize(width: Size.screenWidth, height: 210)
  }

  // MARK: UI Components

  private let navigationBarView = NavBarWithBackButtonView(
    title: "알림",
    rightButtonText: "",
    isSeparatorLineHidden: false)

  private let alarmSettingCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: AlarmSettingFirstCollectionViewCell.self)
    collectionView.register(cell: AlarmSettingCollectionViewCell.self)
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()

  // MARK: Life Cycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    alarmSettingCollectionView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    render()
    self.showLoading()
    bind()
  }

  // MARK: Setup UI

  private func setup() {
    self.view.backgroundColor = .white
    alarmSettingCollectionView.backgroundColor = .white
    alarmSettingCollectionView.delegate = self
    navigationController?.navigationBar.isHidden = true
  }

  // MARK: Bind

  private func bind() {

    // input

    let viewWillAppear = rx.rxViewWillAppear
      .asSignal(onErrorJustReturn: ())

    let actionDetected = PublishSubject<ProfileAlarmSettingActionControl>()

    navigationBarView.backButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { _ in
        actionDetected.onNext(.didTabBack)
      })
      .disposed(by: disposeBag)

    let input = ProfileAlarmSettingViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )

    // output

    let output = viewModel.transform(input: input)

    output.alarmSettingModel
      .do(onNext: { _ in
        self.hideLoading()
      })
      .map {
        [AlarmSettingModel](repeating: $0, count: 6)
      }
      .observe(on: MainScheduler.asyncInstance)
      .bind(to: alarmSettingCollectionView.rx.items) {
        (_: UICollectionView, index: Int, element: AlarmSettingModel) in
        let indexPath = IndexPath(row: index, section: 0)
        let cellTypes: [AlarmSettingCellType] = [.newRules, .newTodo, .todayTodo, .notDoneTodo, .badgeAlarm]
        if indexPath.row == 0 {
          guard let cell =
                  self.alarmSettingCollectionView.dequeueReusableCell(
                    withReuseIdentifier: AlarmSettingFirstCollectionViewCell.className,
                    for: indexPath) as? AlarmSettingFirstCollectionViewCell
          else { print("Cell Loading ERROR!"); return UICollectionViewCell() }
          cell.bind(data: element)

          cell.cellActionControlSubject
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { data in
              actionDetected.onNext(data)
            })
            .disposed(by: cell.disposeBag)
          return cell
        } else {
          guard let cell =
                  self.alarmSettingCollectionView.dequeueReusableCell(
                    withReuseIdentifier: AlarmSettingCollectionViewCell.className,
                    for: indexPath) as? AlarmSettingCollectionViewCell
          else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(data: element, cellType: cellTypes[index - 1])

          cell.cellActionControl
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { data in
              actionDetected.onNext(data)
            })
            .disposed(by: cell.disposeBag)

          self.temporarilySetCellSubject
            .bind(onNext: { [weak self] in
              guard let self = self else { return }
              cell.bind(data: self.viewModel.currentData, cellType: cellTypes[index - 1])
            })
            .disposed(by: cell.disposeBag)

          return cell
        }
      }
      .disposed(by: disposeBag)

    output.actionControl
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.doNavigation(action: $0)
        self.temporarilySetCell(action: $0)
      })
      .disposed(by: disposeBag)
  }

  // MARK: Methods

  private func doNavigation(action: ProfileAlarmSettingActionControl) {
    switch action {
    case .didTabBack:
      self.navigationController?.popViewController(animated: true)
    default:
      break
    }
  }

  private func temporarilySetCell(action: ProfileAlarmSettingActionControl) {
    switch action {
    case .temporarilySetCellForSwitchAnimation:
      self.temporarilySetCellSubject.onNext(())
    default:
      break
    }
  }

  // MARK: Render

  private func render() {
    view.addSubViews([navigationBarView, alarmSettingCollectionView])

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    alarmSettingCollectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension ProfileAlarmSettingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch indexPath.row {
    case 0:
      return Size.oneOptionCellSize
    case 1, 5:
      return Size.twoOptionCellSize
    case 2, 3, 4:
      return Size.threeOptionCellSize
    default:
      return CGSize(width: 0, height: 0)
    }
  }
}
