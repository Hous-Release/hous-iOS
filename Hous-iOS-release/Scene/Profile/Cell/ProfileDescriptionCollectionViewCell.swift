//
//  ProfileDescriptionCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/14.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileDescriptionCellDelegate: AnyObject {
  
}

final class ProfileDescriptionCollectionViewCell: UICollectionViewCell {
  
  private let disposeBag: DisposeBag = DisposeBag()
  weak var delegate: ProfileDescriptionCellDelegate?
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private let profileDescriptionCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 24
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.estimatedItemSize = CGSize(width: 126, height: 74)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: ProfileDescriptionInnerCollectionViewCell.self)
    return collectionView
  }()
  
  
  //MARK: Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    bind()
    render()
    transferToViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .blue
  }
  
  private func bind() {
    let personalityAttributeDescriptionObservable:Observable<[PersonalityAttributeDescription]> = Observable.of(personalityAttributeDescriptions)
    print(personalityAttributeDescriptions[0])
    
    personalityAttributeDescriptionObservable
      .bind(to: profileDescriptionCollectionView.rx.items) {
        (collectionView: UICollectionView, index: Int, element: PersonalityAttributeDescription) in
        print("bind")
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell =
                self.profileDescriptionCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileDescriptionInnerCollectionViewCell.className, for: indexPath) as? ProfileDescriptionInnerCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
        cell.bind(element)
        return cell
      }
      .disposed(by: disposeBag)
  }
  
  private func render() {
    [profileDescriptionCollectionView].forEach { addSubview($0) }
    
    profileDescriptionCollectionView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(32)
      make.trailing.equalToSuperview()
    }
   
  }
  

  
  private func transferToViewController() {
    
  }
  
  func bind(_ data: ProfileModel) {
    
  }
 
}
