//
//  BaseViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/08/13.
//

import UIKit


class OldBaseViewController: UIViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    defaultUI()
    setNavigationItems()
    setupAppearance()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerPopGesture()
  }

  private func defaultUI() {
    view.backgroundColor = .white
  }

  // MARK: - Private
  private func setNavigationItems() {
    if navigationController?.children.count ?? 0 > 1 {
      let backImage: UIImage?

      backImage = UIImage(systemName:
                            "chevron.backward")?
        .withTintColor(.black)
        .withRenderingMode(.alwaysOriginal)

      let backButton = UIBarButtonItem(image: backImage,
                                       style: .plain,
                                       target: self,
                                       action: #selector(didBack))
      navigationItem.leftBarButtonItem = backButton
    } else {

      let cancelImage: UIImage?
      cancelImage = UIImage(systemName: "xmark")?
        .withTintColor(.black)
        .withRenderingMode(.alwaysOriginal)

      let cancelButton = UIBarButtonItem(image: cancelImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(didCancel))
      navigationItem.leftBarButtonItem = cancelButton
    }
  }

  private func setupAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .white
    appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.shadowColor = .white
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }

  private func registerPopGesture() {
    if navigationController?.children.count ?? 0 > 1 {
      navigationController?.interactivePopGestureRecognizer?.delegate = nil
    } else {
      navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
  }

  func setNavigationBar(isHidden: Bool, animated: Bool = true) {
    navigationController?.setNavigationBarHidden(isHidden, animated: animated)
  }

  @objc func didBack() {
    navigationController?.popViewController(animated: true)
  }
  @objc func didCancel() {
    dismiss(animated: true, completion: nil)
  }
  
}


// MARK: - Private
extension OldBaseViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true
  }
}
