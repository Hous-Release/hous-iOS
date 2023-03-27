//
//  LoadingPresentable.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2023/02/17.
//

import UIKit

protocol LoadingPresentable {
  func showLoading()
  func hideLoading()
}

extension LoadingPresentable where Self: BaseViewController {
  func showLoading() {
    if let loadingView = findLoadingView() {
      loadingView.startAnimating()
    } else {
      let loadingView = LoadingView()

      loadingView.startAnimating()

      view.addSubview(loadingView)

      loadingView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }

  func hideLoading() {
    findLoadingView()?.stopAnimating()
    findLoadingView()?.removeFromSuperview()
  }

  func findLoadingView() -> LoadingView? {
    return view.subviews.compactMap { $0 as? LoadingView }
      .first
  }
}
