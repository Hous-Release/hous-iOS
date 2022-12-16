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

final class ProfileAlarmViewController: LoadingBaseViewController {
  
  //MARK: RX Components
  
  private let disposeBag = DisposeBag()
  private let viewModel = ProfileAlarmViewModel()
  
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let cellSize = CGSize(width: Size.screenWidth, height: 89)
  }
  
  //MARK: UI Components
  
  private let navigationBarView = ProfileNavigationBarView().then {
    $0.titleName.text = "알림"
  }
  
  private let alarmCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: AlarmCollectionViewCell.self)
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  //MARK: Life Cycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setTabBarIsHidden(isHidden: true)
    alarmCollectionView.reloadData()
  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    setup()
    render()
    configLoadingLayout()
    self.showLoading()
    bind()
  }
 
  //MARK: Setup UI
  
  private func setup() {
    self.view.backgroundColor = .white
    alarmCollectionView.backgroundColor = .white
    alarmCollectionView.delegate = self
    navigationController?.navigationBar.isHidden = true
  }
  
  //MARK: Bind
  
  private func bind() {
    
    //input
    
    let viewWillAppear = rx.RxViewWillAppear
      .asSignal(onErrorJustReturn: ())
    
    let actionDetected = PublishSubject<ProfileAlarmActionControl>()
    
    navigationBarView.navigationBackButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { _ in
        actionDetected.onNext(.didTabBack)
      })
      .disposed(by: disposeBag)
    
    alarmCollectionView.rx.contentOffset
      .map{$0.y}
      .bind(onNext: { [weak self] position in
        guard let self = self else { return }
        // 좌변 : 매 시점 보이는 화면의 상단부 y좌표 + 보이는 화면의 Height = 보이는 화면의 하단부 y좌표
        // 우변 : 전체 CollectionView Contents Height - threshold (여기선 10개 셀 남았을 때 작동)
        if position + self.alarmCollectionView.frame.size.height > self.alarmCollectionView.contentSize.height - Size.cellSize.height * 10 {
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
      .bind(to:alarmCollectionView.rx.items) {
        (collectionView: UICollectionView, index: Int, element: AlarmModel) in
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.alarmCollectionView.dequeueReusableCell(withReuseIdentifier: AlarmCollectionViewCell.className, for: indexPath) as? AlarmCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
        
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
    
  }
  
  //MARK: Methods
  
//  private func spinnerControl(isSpinnerOn: Bool) {
//    if isSpinnerOn {
//      let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Size.screenWidth, height: 100))
//      let spinner = UIActivityIndicatorView()
//      spinner.center = footerView.center
//      footerView.addSubview(spinner)
//      spinner.startAnimating()
//      
//    }
//  }
  
  private func doNavigation(action: ProfileAlarmActionControl) {
    switch action {
    case .didTabBack:
      self.setTabBarIsHidden(isHidden: false)
      self.navigationController?.popViewController(animated: true)
    default:
      break
    }
  }
  
  //MARK: Render

  private func render() {
    view.addSubViews([navigationBarView, alarmCollectionView])
    
    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }
    
    alarmCollectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension ProfileAlarmViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return Size.cellSize
  }
}

//extension ProfileAlarmViewController: UIScrollViewDelegate {
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let position = scrollView.contentOffset.y
//    if position > alarmCollectionView.contentSize.height - 100 - scrollView.frame.size.height {
//      print("⭐️")
//    }
//  }
//}
