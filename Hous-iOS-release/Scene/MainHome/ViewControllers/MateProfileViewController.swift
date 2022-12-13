//
//  MateProfileViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class MateProfileViewController: UIViewController {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  var viewModel = MateProfileViewModel()
  var data = ProfileModel()
  var id: String
  
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let profileMainImageCellHeight = CGSize(width: Size.screenWidth, height: 254)
    static let profileInfoCellHeight = CGSize(width: Size.screenWidth, height: 162)
    static let profileGraphCellHeight = CGSize(width: Size.screenWidth, height: 260)
    static let profileAttributeInfoCellHeight = CGSize(width: Size.screenWidth, height: 180)
    static let profileRetryCellHeight = CGSize(width: Size.screenWidth, height: 139)
  }
  
  //MARK: UI Components
  
  private let profileCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    
    let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
    collectionView.register(cell: MateProfileMainImageCollectionViewCell.self)
    collectionView.register(cell: MateProfileInfoCollectionViewCell.self)
    collectionView.register(cell: MateProfileGraphCollectionViewCell.self)
    collectionView.register(cell: MateProfileDescriptionCollectionViewCell.self)
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  //MARK: Life Cycle
  
  init(id: String) {
    self.id = id
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    profileCollectionView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    render()
  }
  
  //MARK: Setup UI
  
  private func setup() {
    self.setTabBarIsHidden(isHidden: true)
    profileCollectionView.backgroundColor = .white
    profileCollectionView.delegate = self
    navigationController?.navigationBar.isHidden = true
  }
  
  //MARK: Bind
  
  private func bind() {
    
    // input
    
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asSignal(onErrorJustReturn: ())
    
    let actionDetected = PublishSubject<MateActionControl>()
    
    let input = MateProfileViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected,
      id: self.id
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.profileModel
      .do {
        self.data = $0
      }
      .map {
        [ProfileModel](repeating: $0, count: 4)
      }
      .bind(to:profileCollectionView.rx.items) {
        (collectionView: UICollectionView, index: Int, element: ProfileModel) in
        let indexPath = IndexPath(row: index, section: 0)
        switch indexPath.row {
        case 0:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: MateProfileMainImageCollectionViewCell.className, for: indexPath) as? MateProfileMainImageCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
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
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: MateProfileInfoCollectionViewCell.className, for: indexPath) as? MateProfileInfoCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        case 2:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: MateProfileGraphCollectionViewCell.className, for: indexPath) as? MateProfileGraphCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          cell.cellActionControlSubject
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { data in
              actionDetected.onNext(data)
            })
            .disposed(by: cell.disposeBag)
          return cell
        case 3:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: MateProfileDescriptionCollectionViewCell.className, for: indexPath) as? MateProfileDescriptionCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
          
        default:
          return UICollectionViewCell()
        }
      }
      .disposed(by: disposeBag)
    
    
    
    output.actionControl
      .subscribe(onNext: {[weak self] in self?.doNavigation(action: $0)})
      .disposed(by: disposeBag)
  }
  
  //MARK: Render
  
  private func render() {
    view.addSubview(profileCollectionView)
    profileCollectionView.snp.makeConstraints { make in
      make.top.bottom.trailing.leading.equalToSuperview()
    }
  }
  
  //MARK: Navigation
  
  private func doNavigation(action: MateActionControl) {
    
    switch action {
    case .didTabDetail:
      let destinationViewController = ProfileDetailViewController(color: self.data.personalityColor, isFromTypeTest: false)
      destinationViewController.view.backgroundColor = .white
      navigationController?.pushViewController(destinationViewController, animated: true)
      
    case .didTabBack:
      navigationController?.popViewController(animated: true)

    default:
      return
    }
  }
}

extension MateProfileViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch indexPath.row {
    case 0:
      return Size.profileMainImageCellHeight
    case 1:
      return Size.profileInfoCellHeight
    case 2:
      return Size.profileGraphCellHeight
    case 3:
      return Size.profileAttributeInfoCellHeight
    default:
      return CGSize(width: 0, height: 0)
    }
  }
}


