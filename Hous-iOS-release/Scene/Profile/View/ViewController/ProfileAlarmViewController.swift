//
//  ProfileAlarmViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class ProfileAlarmViewController: BaseViewController {

  // MARK: RX Components

  private let disposeBag = DisposeBag()
  private let viewModel = ProfileAlarmViewModel()

  // MARK: UI Templetes

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let cellSize = CGSize(width: Size.screenWidth, height: 89)
  }

  // MARK: UI Components

  private let navigationBarView = ProfileNavigationBarView().then {
    $0.titleName.text = "알림"
  }

  private let alarmTableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.register(cell: AlarmTableViewCell.self)
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorStyle = .none
    return tableView
  }()

  // MARK: Life Cycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setTabBarIsHidden(isHidden: true)
    alarmTableView.reloadData()
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
    alarmTableView.backgroundColor = .white
    alarmTableView.delegate = self
    navigationController?.navigationBar.isHidden = true
  }

  // MARK: Bind

  private func bind() {

    // input

    let viewWillAppear = rx.rxViewWillAppear
      .asSignal(onErrorJustReturn: ())

    let actionDetected = PublishSubject<ProfileAlarmActionControl>()

    navigationBarView.navigationBackButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { _ in
        actionDetected.onNext(.didTabBack)
      })
      .disposed(by: disposeBag)

    alarmTableView.rx.contentOffset
      .map {$0.y}
      .bind(onNext: { [weak self] position in
        guard let self = self else { return }
        // 좌변 : 매 시점 보이는 화면의 상단부 y좌표 + 보이는 화면의 Height = 보이는 화면의 하단부 y좌표
        // 우변 : 전체 CollectionView Contents Height - threshold (여기선 10개 셀 남았을 때 작동)
        if position + self.alarmTableView.frame.size.height >
            self.alarmTableView.contentSize.height - Size.cellSize.height * 10 {
          actionDetected.onNext(.willFetchNewData)
        }
      })
      .disposed(by: disposeBag)

    let input = ProfileAlarmViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )

    // output

    let output = viewModel.transform(input: input)

    output.alarmModel
      .do(onNext: { _ in
        self.hideLoading()
      })
      .observe(on: MainScheduler.asyncInstance)
      .bind(to: alarmTableView.rx.items) {
        (_: UITableView, index: Int, element: AlarmModel) in
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.alarmTableView.dequeueReusableCell(
          withIdentifier: AlarmTableViewCell.className,
          for: indexPath) as? AlarmTableViewCell else { print("Cell Loading ERROR!"); return UITableViewCell()}
        cell.selectionStyle = .none
        cell.bind(data: element)

        return cell
      }
      .disposed(by: disposeBag)

    output.actionControl
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.doNavigation(action: $0)
      })
      .disposed(by: disposeBag)

    output.isSpinnerOnSignal
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.spinnerControl(isSpinnerOn: $0)
      })
      .disposed(by: disposeBag)
  }

  // MARK: Methods

  private func spinnerControl(isSpinnerOn: Bool) {
    if isSpinnerOn {
      let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Size.screenWidth, height: 100))
      let spinner = UIActivityIndicatorView()
      spinner.center = footerView.center
      footerView.addSubview(spinner)
      spinner.startAnimating()
      self.alarmTableView.tableFooterView = footerView
    } else {
      self.alarmTableView.tableFooterView = nil
    }
  }

  private func doNavigation(action: ProfileAlarmActionControl) {
    switch action {
    case .didTabBack:
      self.setTabBarIsHidden(isHidden: false)
      self.navigationController?.popViewController(animated: true)
    default:
      break
    }
  }

  // MARK: Render

  private func render() {
    view.addSubViews([navigationBarView, alarmTableView])

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    alarmTableView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension ProfileAlarmViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Size.cellSize.height
  }
}
