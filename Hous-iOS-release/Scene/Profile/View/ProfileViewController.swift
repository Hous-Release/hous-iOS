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

final class ProfileViewController: UIViewController {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  var viewModel = ProfileViewModel()
  
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let profileMainImageCellHeight = CGSize(width: Size.screenWidth, height: 254)
    static let profileInfoCellHeight = CGSize(width: Size.screenWidth, height: 176)
    static let profileGraphCellHeight = CGSize(width: Size.screenWidth, height: 250)
    static let profileAttributeInfoCellHeight = CGSize(width: Size.screenWidth, height: 150)
    static let profileRetryCellHeight = CGSize(width: Size.screenWidth, height: 139)
  }
  
  //MARK: UI Components
  
  private let profileCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    
    let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
    collectionView.register(cell: ProfileMainImageCollectionViewCell.self)
    collectionView.register(cell: ProfileInfoCollectionViewCell.self)
    collectionView.register(cell: ProfileGraphCollectionViewCell.self)
    collectionView.register(cell: ProfileDescriptionCollectionViewCell.self)
    collectionView.register(cell: ProfileRetryCollectionViewCell.self)
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  //MARK: Life Cycle
  
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
    
    let actionControl = BehaviorSubject<ProfileActionControl>(value: .none)
    
    let input = ProfileViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionControl: actionControl
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.profileModel
      .map {[ProfileModel](repeating: $0, count: 5)}
      .bind(to:profileCollectionView.rx.items) {
        (collectionView: UICollectionView, index: Int, element: ProfileModel) in
        let indexPath = IndexPath(row: index, section: 0)
        switch indexPath.row {
        case 0:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileMainImageCollectionViewCell.className, for: indexPath) as? ProfileMainImageCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          cell.cellActionControlSubject
            .subscribe(onNext: { data in
              actionControl.onNext(data)
            })
            .disposed(by: self.disposeBag)
          return cell
        case 1:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileInfoCollectionViewCell.className, for: indexPath) as? ProfileInfoCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        case 2:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileGraphCollectionViewCell.className, for: indexPath) as? ProfileGraphCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        case 3:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDescriptionCollectionViewCell.className, for: indexPath) as? ProfileDescriptionCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
          cell.bind(element)
          return cell
        case 4:
          guard let cell =
                  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileRetryCollectionViewCell.className, for: indexPath) as? ProfileRetryCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
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
  }
  
  //MARK: Render
  
  private func render() {
    view.addSubview(profileCollectionView)
    profileCollectionView.snp.makeConstraints { make in
      make.top.bottom.trailing.leading.equalToSuperview()
    }
  }
                
  private func doNavigation(action: ProfileActionControl) {
    let destinationViewController : UIViewController
    
    switch action {
    case .didTabAlarm:
      destinationViewController = ProfileAlarmViewController()
    case .didTabSetting:
      destinationViewController = ProfileSettingViewController()
    default:
      return
    }
    navigationController?.pushViewController(destinationViewController, animated: true)
  }
}
                 
          

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
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
    case 4:
      return Size.profileRetryCellHeight
    default:
      return CGSize(width: 0, height: 0)
    }
  }
}

