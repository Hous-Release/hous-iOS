//
//  RuleBottomSheetView.swift
//  
//
//  Created by 김민재 on 2023/05/30.
//

import UIKit
import SnapKit
import AssetKit


final class RuleBottomSheetView: UIView {

    private typealias SECTION = RuleBottomDataSource.Section
    private typealias ITEM = RuleBottomDataSource.Item
    private typealias DataSource = UICollectionViewDiffableDataSource<SECTION, ITEM>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<SECTION, ITEM>
    private typealias CellReigstration = UICollectionView.CellRegistration

    private enum Size {
        static let leadingTrailingOffset: CGFloat = 70
        static let stackViewVerticalSpacing: CGFloat = 16
        static let stackViewLeadingTrailing: CGFloat = 24
        static let handlerWidth: CGFloat = 80
        static let handlerHeight: CGFloat = 5
    }

    private let rootView: UIView = {
      let view = UIView()
      view.layer.cornerRadius = 20
        view.backgroundColor = Colors.white.color
      view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      return view
    }()

    private let handlerView: UIView = {
      let view = UIView()
      view.backgroundColor = Colors.g3.color
      view.layer.cornerCurve = .continuous
      view.layer.cornerRadius = 5
      return view
    }()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.isScrollEnabled = false
    }

    private let ruleTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.black.color
        label.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
        return label
    }()

    private let lastModifiedDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.g4.color
        label.font = Fonts.Montserrat.medium.font(size: 12)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.g6.color
        label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
        label.lineBreakMode = .byCharWrapping
        label.lineBreakStrategy = .hangulWordPriority
        label.numberOfLines = 0
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Size.stackViewVerticalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: Size.stackViewLeadingTrailing,
            bottom: 0,
            right: Size.stackViewLeadingTrailing)
        return stackView
    }()

    lazy var modifyButton: UIButton = {
      let button = UIButton()
      button.setTitle("수정하기", for: .normal)
      button.setTitleColor(Colors.black.color, for: .normal)
        button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
      button.titleLabel?.textAlignment = .center
      return button
    }()

    lazy var deleteButton: UIButton = {
      let button = UIButton()
      button.setTitle("삭제하기", for: .normal)
      button.setTitleColor(Colors.red.color, for: .normal)
        button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
      button.titleLabel?.textAlignment = .center
      return button
    }()

    private var dataSource: DataSource?

    init(model: PhotoCellModel) {
        super.init(frame: .zero)
        setLayout(photos: model.photos)
        configViewLabel(model)
        configureDataSource()
        applySnapshot()
        applyPhotoSnapshot(model.photos?.uniqued() ?? [])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }

}

private extension RuleBottomSheetView {

    func configViewLabel(_ model: PhotoCellModel) {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = inputDateFormatter.date(from: model.lastmodifedDate) {
            let myFormatter = DateFormatter()
            myFormatter.dateFormat = "yyyy.MM.dd"
            let str = myFormatter.string(from: date)
            self.lastModifiedDateLabel.text = "마지막 수정 \(str)"
        }

        self.ruleTitleLabel.text = model.title

        if model.description == nil {
            self.descriptionLabel.text = "설명 없음"
            self.descriptionLabel.textColor = Colors.g4.color
            return
        }
        self.descriptionLabel.text = model.description

    }


    func setLayout(photos: [RulePhoto]?) {
        self.addSubview(rootView)
        [handlerView,
         collectionView,
         ruleTitleLabel,
         lastModifiedDateLabel,
         descriptionLabel,
         buttonStackView].forEach {
            rootView.addSubview($0)
        }

        rootView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        handlerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(12)
            make.width.equalTo(Size.handlerWidth)
            make.height.equalTo(Size.handlerHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(handlerView.snp.bottom).offset(32)
            make.height.equalTo(230)
            make.leading.trailing.equalToSuperview()
        }

        configCollectionViewLayout(photos: photos)

        lastModifiedDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(ruleTitleLabel)
            make.top.equalTo(ruleTitleLabel.snp.bottom).offset(12)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(lastModifiedDateLabel.snp.bottom).offset(3)
            make.leading.equalTo(ruleTitleLabel)
            make.trailing.equalToSuperview().inset(24)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(26)
        }

        let line1 = makeG2LineView()
        let line2 = makeG2LineView()

        [modifyButton, deleteButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(26)
            }
        }

        [line1, line2].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }

        buttonStackView.addArrangedSubview(line1)
        buttonStackView.addArrangedSubview(modifyButton)
        buttonStackView.addArrangedSubview(line2)
        buttonStackView.addArrangedSubview(deleteButton)
    }

    func configCollectionViewLayout(photos: [RulePhoto]?) {
        if photos == nil {
            collectionView.isHidden = true
            ruleTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(handlerView.snp.bottom).offset(24)
                make.leading.equalToSuperview().inset(24)
            }
            return
        }
        collectionView.isHidden = false
        ruleTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(24)
        }
    }

    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (
          sectionIndex: Int,
          layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in

          guard
            let self = self,
            let sectionKind = RuleBottomDataSource.Section(rawValue: sectionIndex)
          else {
            return nil
          }

          let section: NSCollectionLayoutSection

          switch sectionKind {
          case .photos:
            section = self.createPhotoSection()
          }

          return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    func createPhotoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(226 / 375),
            heightDimension: .fractionalWidth(226 / 375))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 14)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Size.leadingTrailingOffset,
            bottom: 0,
            trailing: Size.leadingTrailingOffset)
        return section
    }

    func makeG2LineView() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.g2.color
        return view
    }

    func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height

        collectionView.snp.updateConstraints { make in
          make.height.equalTo(height)
        }
    }

}


private extension RuleBottomSheetView {

    func applySnapshot() {
        var snapshot = SnapShot()
        let sections = SECTION.allCases
        snapshot.appendSections(sections)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func applyPhotoSnapshot(_ photos: [RulePhoto]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<ITEM>()
        let items = photos.map {
            ITEM.photos($0)
        }
        snapshot.append(items)
        dataSource?.apply(snapshot, to: .photos)
    }

    func configureDataSource() {
        let photoCellRegistration = CellReigstration<PhotoCollectionViewCell, RulePhoto> { cell, _, model in
            cell.configurePhotoCell(model)
        }

        self.dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .photos(let model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: photoCellRegistration,
                    for: indexPath,
                    item: model)
            }
        })
    }
}
