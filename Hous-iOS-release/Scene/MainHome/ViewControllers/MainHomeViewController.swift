//
//  HousViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/07.
//

import UIKit
import SnapKit
import Then

class MainHomeViewController: UIViewController {
  //MARK: - Vars & Lets
  private enum MainHomeSection: Int {
    case todoAndRules = 0
    case homiesProfiles
  }
  
  //MARK: - UI Components
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical

    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
  }
  
  //MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    configCollectionView()
  }
  
  private func configUI() {
    view.backgroundColor = .systemBackground
    navigationController?.isNavigationBarHidden = true
    view.addSubview(collectionView)
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(MainHomeTodoCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeTodoCollectionViewCell.identifier)
    collectionView.register(MainHomeProfileCollectionViewCell.self, forCellWithReuseIdentifier: MainHomeProfileCollectionViewCell.identifier)
  }
  
}


//MARK: - CollectionView Delegate & DataSource
extension MainHomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == MainHomeSection.todoAndRules.rawValue {
      return 1
    }
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.section == MainHomeSection.todoAndRules.rawValue {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeTodoCollectionViewCell.identifier, for: indexPath) as? MainHomeTodoCollectionViewCell else { return UICollectionViewCell()
      }
      
      return cell
    }
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHomeProfileCollectionViewCell.identifier, for: indexPath) as? MainHomeProfileCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    return cell
  }
}

extension MainHomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    // TODO: - Section 높이 지정 방법..
    if indexPath.section == MainHomeSection.todoAndRules.rawValue {
      return CGSize(width: UIScreen.main.bounds.width, height: 640)
    }
    
    let width = UIScreen.main.bounds.width / 2 - 35
    let height = width * 0.6451612903
    
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
      if section == MainHomeSection.homiesProfiles.rawValue { return 12 }
      return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    if section == MainHomeSection.homiesProfiles.rawValue { return 17 }
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == MainHomeSection.homiesProfiles.rawValue {
      return UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
    }
    return UIEdgeInsets()
  }
}
