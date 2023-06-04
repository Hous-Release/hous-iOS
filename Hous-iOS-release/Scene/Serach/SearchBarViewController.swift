//
//  SearchBarViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit

final class SearchBarViewController: UIViewController {

  let searchBarView = UIView()
  let searchBar = HousSearchBar()

  lazy var filterView = FilterView()

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.createLayout())

  let floatingButton = PlusFloatingButton()

  init(_ type: SearchBarViewType) {
    super.init(nibName: nil, bundle: nil)
    configUI(type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

private extension SearchBarViewController {

  func createLayout() -> UICollectionViewLayout {
    let config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
    return UICollectionViewCompositionalLayout.list(using: config)
  }

  func configUI(_ type: SearchBarViewType) {

    var subViews: [UIView] = [
      searchBarView,
      collectionView,
      floatingButton
    ]
    if type == .todo { subViews.append(filterView) }
    self.view.addSubViews(subViews)
    searchBarView.addSubview(searchBar )

    // 그 다음에는 필터뷰 커스텀하고, 컬렉션뷰 만들자

    searchBarView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    searchBar.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(8)
      make.leading.trailing.equalToSuperview().inset(24)
    }

    if type == .todo {
      filterView.snp.makeConstraints { make in
        make.top.equalTo(searchBarView.snp.bottom)
        make.leading.trailing.equalToSuperview()
        make.height.equalTo(Button.Filter.height)
      }
    }

    collectionView.snp.makeConstraints { make in
      if type == .todo {
        make.top.equalTo(filterView.snp.bottom)
      } else {
        make.top.equalTo(searchBarView.snp.bottom).offset(8)
      }
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    floatingButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
      make.trailing.equalToSuperview().inset(36)
    }
  }

}
