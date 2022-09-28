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
    
  }
  
  //MARK: UI Components
  
  private let profileCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  //MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    render()
    bind()
  }
  
  //MARK: Setup UI
  
  private func setup() {
    
  }
  
  //MARK: Bind
  
  private func bind() {
    //input
    //output
  }
  
  //MARK: Render
  
  private func render() {
    //    view.snp.makeConstraints { make in
    //    make.height.equalTo(60)
    //    make.leading.trailing.equalToSuperview()
  }
  
}
