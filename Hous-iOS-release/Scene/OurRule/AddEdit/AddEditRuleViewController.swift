//
//  AddEditRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/18.
//

import UIKit
import BottomSheetKit
import PhotosUI
import RxSwift

struct CreateRuleRequestDTO {
  var ruleId: Int?
  let name: String
  let description: String
  let images: [UIImage]

  init(ruleId: Int? = nil, name: String, description: String, images: [UIImage]) {
    self.ruleId = ruleId
    self.name = name
    self.description = description
    self.images = images
  }
}

@frozen
enum AddEditType {
  case addRule
  case updateRule

  var titleText: String {
    switch self {
    case .addRule: return "Rule 추가"
    case .updateRule: return "Rule 수정"
    }
  }

  var rightButtonText: String {
    switch self {
    case .addRule: return "추가"
    case .updateRule: return "저장"
    }
  }
}

final class AddEditRuleViewController: BaseViewController, LoadingPresentable {

  @frozen
  enum Section: Int, CaseIterable {
    case titleAndDescription = 0
    case photoInput
  }

  // MARK: - UI Components

  private let navigationBar = NavBarWithBackButtonView()

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
    $0.isScrollEnabled = false
  }

  // MARK: - Properties
  private var ruleTitle: String = ""
  private var ruleDescription: String = ""

  private let maxImageCount = 5

  private var dataSource: UICollectionViewDiffableDataSource<Section, RulePhoto>?

  private let disposeBag = DisposeBag()

  private let albumImageUploadedSubject = PublishSubject<Void>()
  private let currPhotoCountSubject = PublishSubject<Int>()

  private let toCreateRule = PublishSubject<CreateRuleRequestDTO>()
  private let toUpdateRule = PublishSubject<CreateRuleRequestDTO>()
  private let viewModel: AddEditViewModel
  private let type: AddEditType
  private let photoCellModel: PhotoCellModel?

  init(viewModel: AddEditViewModel, type: AddEditType, model: PhotoCellModel? = nil) {
    self.type = type
    self.viewModel = viewModel
    self.photoCellModel = model
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setLayout()
    configureDataSource()
    collectionView.dataSource = dataSource
    bind()
    configUI()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)

  }

  private func setLayout() {

    view.addSubViews([
      navigationBar,
      collectionView
    ])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }

  }

  private func configUI() {
    navigationBar.rightButtonText = type.rightButtonText
    navigationBar.title = type.titleText

  }

  private func bind() {
    collectionView.rx.tapGesture()
      .asDriver()
      .drive(onNext: { _ in
        self.collectionView.endEditing(true)
      })
      .disposed(by: disposeBag)

//    print(dataSource.snapshot(for: .photoInput).items)

    navigationBar.rightButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        guard let images = dataSource?.snapshot(for: .photoInput).items.map({ model in
          return model.image
        })
        else { return }

        // TODO: - 규칙 수정 API
        /*
         1. ruleId와 PhotoCellModel를 이쪽 VC로 넘어올 때 받아온다. <- 메서드? 변수에 넣어주기?
         2. PhotoCellModel에서 받아온 정보로 View에 데이터 넣어주기 <- 이건 이 VC present해주는 RulesViewController쪽에서 메서드 호출.
         3. 그리고 뷰가 보여지고 수정할 거 하고 '저장' 버튼을 누르면 담고 있던 RuleId과 model을 viewModel로 넘긴다.
         4. viewModel에서 넘겨받은 ruleId와 이미지 등등을 이용해서 규칙 수정 API 호출하기
         5. API 호출 후 성공이면 pop
         */

        var model = CreateRuleRequestDTO(name: self.ruleTitle, description: self.ruleDescription, images: images)
        if type == .updateRule {
          model.ruleId = photoCellModel?.ruleId
        }

        self.toCreateRule.onNext(model)
      })
      .disposed(by: disposeBag)

    let input = AddEditViewModel.Input(addButtonDidTap: toCreateRule)
    let output = viewModel.transform(input)
    output.createdRule
      .drive(onNext: { _ in
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)

//    let input = AddRuleViewModel.Input(
    //      navBackButtonDidTapped: navigationBar.backButton.rx.tap.asObservable(),
    //      viewDidTapped: view.rx.tapGesture().asObservable(),
    //      saveButtonDidTapped: newRulesSubject
    //        .do(onNext: { [weak self] _ in self?.showLoading() }),
    //      plusButtonDidTapped: plusButton.rx.tap.asObservable(),
    //      textFieldEdit: ruleTextField.rx.text
    //        .orEmpty
    //        .distinctUntilChanged()
    //        .asObservable()
    //    )
  }

}

// MARK: - UI & Layout

extension AddEditRuleViewController {

  func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in

      guard let section = Section(rawValue: sectionIndex) else { return nil }

      switch section {
      case .titleAndDescription:
        return self.createTitleSectionLayout(section: section)
      case .photoInput:
        return self.createPhotoInputSectionLayout(section: section)
      }
    }

    return layout
  }

  func createTitleSectionLayout(section: Section) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    return section
  }

  func createPhotoInputSectionLayout(section: Section) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 12)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.45),
      heightDimension: .fractionalWidth(0.45))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)

    section.orthogonalScrollingBehavior = .continuous

    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                         heightDimension: .estimated(50)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .topLeading)
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }
}

extension AddEditRuleViewController {
  func configureDataSource() {
    let titleCellRegistration = UICollectionView.CellRegistration<TitleDetailCollectionViewCell, Int> {cell, _, _ in

      if let model = self.photoCellModel {
        cell.textField.text = model.title
        cell.textView.textView.text = model.description
      }

      cell.textField.rx.text
        .orEmpty
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: "")
        .drive(onNext: { [weak self] text in
          guard let self else { return }
          self.ruleTitle = text
        })
        .disposed(by: cell.disposeBag)

      cell.textView.textView.rx.text
        .orEmpty
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: "")
        .drive(onNext: { [weak self] text in
          guard let self else { return }
          self.ruleDescription = text
        })
        .disposed(by: cell.disposeBag)

    }

    let photoCellRegistration = UICollectionView.CellRegistration<PhotoCollectionViewCell, RulePhoto> { cell, _, item in

      cell.buttonTapSubject
        .asDriver(onErrorJustReturn: ())
        .drive(onNext: {
          guard let dataSource = self.dataSource else {
            return
          }

          var snapshot = dataSource.snapshot()

          snapshot.deleteItems([item])
          self.currPhotoCountSubject.onNext(snapshot.numberOfItems(inSection: .photoInput))
          DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
          }
        })
        .disposed(by: cell.disposeBag)

      cell.configPhotoCell(image: item.image)
    }

    let supplementaryRegistration = UICollectionView.SupplementaryRegistration
    <HeaderCollectionReusableView>(elementKind: UICollectionView.elementKindSectionHeader) {
      (supplementaryView, _, _) in

      self.currPhotoCountSubject
        .asDriver(onErrorJustReturn: 0)
        .map { $0 < self.maxImageCount }
        .drive(onNext: { flag in
          supplementaryView.updateButtonState(isEnable: flag)
        })
        .disposed(by: self.disposeBag)

      supplementaryView.plusButtonTapSubject
        .asDriver(onErrorJustReturn: ())
        .drive(onNext: { _ in
          guard let dataSource = self.dataSource else { return }
          let currPhotoCount = dataSource.snapshot().itemIdentifiers(inSection: .photoInput).count

          var configuration = PHPickerConfiguration()

          configuration.selectionLimit = self.maxImageCount - currPhotoCount
          configuration.filter = .images

          let picker = PHPickerViewController(configuration: configuration)
          if #available(iOS 16.0, *) {
            picker.delegate = self
          } else {
            // Fallback on earlier versions
          }
          self.present(picker, animated: true)
        })
        .disposed(by: self.disposeBag)
    }

    dataSource = UICollectionViewDiffableDataSource<Section, RulePhoto>(
      collectionView: collectionView,
      cellProvider: {
        collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in

        guard let section = Section(rawValue: indexPath.section) else { return nil}
        switch section {
        case .titleAndDescription:
          return collectionView
            .dequeueConfiguredReusableCell(using: titleCellRegistration, for: indexPath, item: 1)
        case .photoInput:

          return collectionView
            .dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: itemIdentifier)
        }
      })

    dataSource?.supplementaryViewProvider = { (collectionView, _, indexPath) -> UICollectionReusableView? in
      return collectionView
        .dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
    }

    var snapshot = NSDiffableDataSourceSnapshot<Section, RulePhoto>()

    // MARK: - 초기 세팅
    Section.allCases.forEach {
      snapshot.appendSections([$0])
      if $0 == .photoInput {
        return
      }
      snapshot.appendItems([RulePhoto(image: UIImage())])

    }

    // MARK: - '수정하기' 선택 시 초기 이미지들 적용

    if let images = photoCellModel?.photos {
      images.forEach { rulePhoto in
        print(rulePhoto.image)
        DispatchQueue.global().async { [weak self] in
          guard let url = URL(string: rulePhoto.image) else {
            return

          }
          if let data = try? Data(contentsOf: url) {
              if let image = UIImage(data: data) {
                  DispatchQueue.main.async {
                    snapshot.appendItems([RulePhoto(image: image)], toSection: .photoInput)
                    self?.dataSource?.apply(snapshot, animatingDifferences: true)
                  }
              }
          }
        }
      }
    } else {
      dataSource?.apply(snapshot, animatingDifferences: true)
    }

  }

}

@available(iOS 16.0, *)
extension AddEditRuleViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    guard let dataSource = self.dataSource else { return }
    let snapshot = dataSource.snapshot()
    let prev = snapshot.numberOfItems(inSection: .photoInput)
    self.currPhotoCountSubject.onNext(prev + results.count)

    results.forEach { result in
      result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in

        DispatchQueue.main.async {
          guard let image = reading as? UIImage,
                error == nil else { return }
          guard let dataSource = self.dataSource else { return }
          var snapshot = dataSource.snapshot()
          snapshot.appendItems([RulePhoto(image: image)], toSection: .photoInput)
          dataSource.apply(snapshot, animatingDifferences: true)
        }
      }
    }

    picker.dismiss(animated: true)

//    albumImageUploadedSubject
//      .asDriver(onErrorJustReturn: ())
//      .drive(onNext: {
//        picker.dismiss(animated: true)
//      })
//      .disposed(by: disposeBag)
  }

}
