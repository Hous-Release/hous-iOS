//
//  SearchBarViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit


final class SearchBarViewController: UIViewController {

  let searchBar = HousSearchBar()

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.createLayout())

  let floatingButton = PlusFloatingButton()

  init(_ type: SearchBarViewType) {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
  }
}

private extension SearchBarViewController {

  func createLayout() -> UICollectionViewLayout {
    let config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
    return UICollectionViewCompositionalLayout.list(using: config)
  }

  func configUI() {
    self.view.addSubViews([
      searchBar,
      collectionView,
      floatingButton
    ])

    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.leading.trailing.equalToSuperview().inset(24)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    floatingButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
      make.trailing.equalToSuperview().inset(36)
    }
  }

}
