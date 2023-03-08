//
//  ProfileDetailViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//
import UIKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileDetailViewController: BaseViewController, UICollectionViewDelegate {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  var viewModel: ProfileDetailViewModel
  var color: PersonalityColor
  var isFromTypeTest: Bool
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let imageCellSize = CGSize(width: Size.screenWidth, height: 380)
    static let textCellSize = CGSize(width: Size.screenWidth, height: 300)
    static let textSmallCellSize = CGSize(width: Size.screenWidth, height: 300)
    static let recommendCellSize = CGSize(width: Size.screenWidth, height: 240)
  }
  
  //MARK: UI Components
  
  private lazy var navigationBarView = ProfileDetailNavigationBarView(isFromTypeTest: self.isFromTypeTest)
  
  private let profileDetailCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
    
    let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
    collectionView.register(cell: ProfileDetailImageCollectionViewCell.self)
    collectionView.register(cell: ProfileDetailTextCollectionViewCell.self)
    collectionView.register(cell: ProfileDetailRecommendCollectionViewCell.self)
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  //MARK: Life Cycle
  
  init(color: PersonalityColor, isFromTypeTest: Bool) {
    self.color = color
    self.viewModel = ProfileDetailViewModel(color: color)
    self.isFromTypeTest = isFromTypeTest
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    profileDetailCollectionView.reloadData()
    self.setTabBarIsHidden(isHidden: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    render()
    self.showLoading()
    bind()
  }
  
  //MARK: Setup UI
  
  private func setup() {
    profileDetailCollectionView.backgroundColor = .white
    profileDetailCollectionView.delegate = self
    navigationController?.navigationBar.isHidden = true
  }
  
  //MARK: Bind
  
  private func bind() {
    
    // input
    
    let viewWillAppear = rx.rxViewWillAppear
      .asSignal(onErrorJustReturn: ())
      
    
    let actionDetected = PublishSubject<ProfileDetailActionControl>()
    
    navigationBarView.viewActionControlSubject
      .subscribe(onNext: { data in
        actionDetected.onNext(data)
        print(data)
      })
      .disposed(by: disposeBag)
    
    let input = ProfileDetailViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.profileDetailModel
      .do(onNext: { _ in
          self.hideLoading()
        })
      .map {[ProfileDetailModel](repeating: $0, count: 3)}
      .bind(to:profileDetailCollectionView.rx.items) {
        (collectionView: UICollectionView, index: Int, element: ProfileDetailModel) in
        let indexPath = IndexPath(row: index, section: 0)
        
        switch indexPath.row {
        case 0:
          guard let cell =
                  self.profileDetailCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDetailImageCollectionViewCell.className, for: indexPath) as? ProfileDetailImageCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        case 1:
          guard let cell =
                  self.profileDetailCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDetailTextCollectionViewCell.className, for: indexPath) as? ProfileDetailTextCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        case 2:
          guard let cell =
                  self.profileDetailCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDetailRecommendCollectionViewCell.className, for: indexPath) as? ProfileDetailRecommendCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        default:
          print("Cell Loading ERROR!")
          return UICollectionViewCell()
        }
      }
      .disposed(by: disposeBag)
    
    output.actionControl
      .subscribe(onNext: {[weak self] in self?.doNavigation(action: $0)})
      .disposed(by: disposeBag)
    
    output.profileDetailModel
      .subscribe(onNext: {[weak self] data in
        self?.profileDetailCollectionView.reloadData()})
      .disposed(by: disposeBag)
  }
  
  //MARK: Render
  
  private func render() {
    view.addSubViews([navigationBarView, profileDetailCollectionView])
    
    navigationBarView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    
    profileDetailCollectionView.snp.makeConstraints { make in
      make.bottom.trailing.leading.equalToSuperview()
      make.top.equalTo(navigationBarView.snp.bottom)
    }
  }
  
  //MARK: Navigation
  
  private func doNavigation(action: ProfileDetailActionControl) {
    switch action {
    case .didTabBack:
      if self.isFromTypeTest {
        let housTabbarViewController = HousTabbarViewController()
        self.view.window?.rootViewController = housTabbarViewController
        self.view.window?.makeKeyAndVisible()
        
        housTabbarViewController.housTabBar.selectItem(index: 2)
        
        self.view.window?.rootViewController?.dismiss(animated: true)
        
      } else {
        setTabBarIsHidden(isHidden: false)
        navigationController?.popViewController(animated: true)
      }
    case .none:
      return
    }
  }
}

extension ProfileDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch indexPath.row {
    case 0:
      return Size.imageCellSize
    case 1:
      return Size.textCellSize
    case 2:
      return Size.recommendCellSize
    default:
      return CGSize(width: 0, height: 0)
    }
  }
}

