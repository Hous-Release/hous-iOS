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
  var viewModel: ProfileViewModel = ProfileViewModel()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  //MARK: UI Components
  
  private let profileCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    layout.estimatedItemSize = CGSize(width: Size.screenWidth, height: 254)
    let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
    collectionView.register(cell: ProfileMainImageCollectionViewCell.self)
    collectionView.contentInsetAdjustmentBehavior = .never
    return collectionView
  }()
  
  //MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    render()
  }
  
  //MARK: Setup UI
  
  private func setup() {
    profileCollectionView.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
  }
  
  //MARK: Bind
  
  private func bind() {
    
    
    let data = ["왕짱파워똑똑이"]
    let dataOb:Observable<[String]> = Observable.of(data)
    
    dataOb
      .bind(to:profileCollectionView.rx.items){
        (collectionView: UICollectionView,
         index: Int,
         element: String) in
        let indexPath = IndexPath(row: index, section: 0)
        print("bind")
        guard let cell =  self.profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileMainImageCollectionViewCell.className, for: indexPath) as? ProfileMainImageCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
        cell.bedgeLabel.text = element
        return cell
      }
      .disposed(by: disposeBag)
    
   
  }
  
  //MARK: Render
  
  private func render() {
    view.addSubview(profileCollectionView)
    profileCollectionView.snp.makeConstraints { make in
      make.top.bottom.trailing.leading.equalToSuperview()
    }
  }
}

//extension ProfileViewController: UICollectionViewDelegateFlowLayout {
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    print(1)
//    return CGSize(width: Size.screenWidth, height: 254)
//  }
//}
