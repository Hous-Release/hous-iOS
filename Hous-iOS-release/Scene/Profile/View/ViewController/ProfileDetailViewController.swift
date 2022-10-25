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

final class ProfileDetailViewController: UIViewController, UICollectionViewDelegate {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  var viewModel = ProfileDetailViewModel()
  
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let imageCellSize = CGSize(width: Size.screenWidth, height: 340)
    static let textCellSize = CGSize(width: Size.screenWidth, height: 320)
    static let textSmallCellSize = CGSize(width: Size.screenWidth, height: 300)
    static let recommendCellSize = CGSize(width: Size.screenWidth, height: 100)
  }
  
  //MARK: UI Components
  
  private let navigationBarView = ProfileDetailNavigationBarView()
  
  private let profileDetailCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    
    let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
    collectionView.register(cell: ProfileDetailImageCollectionViewCell.self)
    collectionView.register(cell: ProfileDetailTextCollectionViewCell.self)
    collectionView.register(cell: ProfileDetailRecommendCollectionViewCell.self)
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  //MARK: Life Cycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    profileDetailCollectionView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    render()
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
    
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asSignal(onErrorJustReturn: ())
    
    let input = ProfileDetailViewModel.Input(
      viewWillAppear: viewWillAppear
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.profileDetailModel
      .map {[ProfileDetailModel](repeating: $0, count: 3)}
      .bind(to:profileDetailCollectionView.rx.items) {
        (collectionView: UICollectionView, index: Int, element: ProfileDetailModel) in
        let indexPath = IndexPath(row: index, section: 0)
        
        switch indexPath.row {
        case 0:
          guard let cell =
                  self.profileDetailCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDetailImageCollectionViewCell.className, for: indexPath) as? ProfileDetailImageCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
//          cell.bind(element)
          return cell
        case 1:
          guard let cell =
                  self.profileDetailCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDetailTextCollectionViewCell.className, for: indexPath) as? ProfileDetailTextCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
//          cell.bind(element)
          return cell
        case 2:
          guard let cell =
                  self.profileDetailCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDetailRecommendCollectionViewCell.className, for: indexPath) as? ProfileDetailRecommendCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
//          cell.bind(element)
          return cell
        default:
          print("Cell Loading ERROR!")
          return UICollectionViewCell()
        }
      }
      .disposed(by: disposeBag)
    
//    output.actionControlz
//      .subscribe(onNext: {[weak self] in self?.doNavigation(action: $0)})
//      .disposed(by: disposeBag)
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
  
//  private func doNavigation(action: ProfileActionControl) {
//    let destinationViewController : UIViewController
//
//    switch action {
//    case .didTabBack:
//      navigationController?.popViewController(animated: true)
//    case .none:
//      return
//    }
//    navigationController?.pushViewController(destinationViewController, animated: true)
//  }
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

