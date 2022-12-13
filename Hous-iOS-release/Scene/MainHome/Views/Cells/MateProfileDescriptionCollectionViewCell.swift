//
//  MateProfileDescriptionCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit
import RxSwift
import RxCocoa

final class MateProfileDescriptionCollectionViewCell: UICollectionViewCell {
  
  var disposeBag: DisposeBag = DisposeBag()
  
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
    layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    layout.itemSize = CGSize(width: 136, height: 102)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cell: MateProfileDescriptionInnerCollectionViewCell.self)
    return collectionView
  }()
  
  //MARK: Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .white
  }
  
  private func bind() {
    let personalityAttributeDescriptionObservable:Observable<[PersonalityAttributeDescription]> = Observable.of(personalityAttributeDescriptions)
    
    personalityAttributeDescriptionObservable
      .bind(to: profileDescriptionCollectionView.rx.items) {
        (collectionView: UICollectionView, index: Int, element: PersonalityAttributeDescription) in
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.profileDescriptionCollectionView
          .dequeueReusableCell(withReuseIdentifier: MateProfileDescriptionInnerCollectionViewCell.className, for: indexPath) as?
           MateProfileDescriptionInnerCollectionViewCell else { print("Cell Loading ERROR!"); return UICollectionViewCell()}
        cell.bind(element)
        return cell
      }
      .disposed(by: disposeBag)
  }
  
  private func render() {
    addSubview(profileDescriptionCollectionView)
    
    profileDescriptionCollectionView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
  }
  
  func bind(_ data: ProfileModel) {
    
  }
}
