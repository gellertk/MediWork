//
//  ViewController.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import UIKit
import Combine

final class PatientsViewController: UIViewController {
    
    private struct Item: Hashable {
        private let identifier = UUID()
        
        let label: String
        let value: String?
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Patient, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Patient, Item>
    private typealias HeaderRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    
    // MARK: - Variables
    
    private let viewModel: PatientsViewModel

    private var bag: Set<AnyCancellable> = .init()
    
    // MARK: - Outlets
    
    private let stateView: StateView = {
        let stateView: StateView = .init()
        stateView.translatesAutoresizingMaskIntoConstraints = false
        return stateView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    private lazy var sortingPickerView: SortingPickerView = {
        let sortingFields: [SortField] = RowProperty.allCases.map { .init(rowProperty: $0, withDirections: true) }
        let view: SortingPickerView = .init(sortingFields: sortingFields)
        view.onApply = { [weak self] sortField, sortDirection in
            guard let self else { return }
            self.applyCurrentSnapshot(with: sortField, and: sortDirection)
        }
        return view
    }()
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: self.collectionView) { (collectionView: UICollectionView,
                                                                            indexPath: IndexPath,
                                                                            item: Item) -> UICollectionViewCell? in
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: self.headerRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: item)
            }
        }
        return dataSource
    }()
    
    private let headerRegistration: HeaderRegistration = {
        let headerRegistration = HeaderRegistration { (cell, _, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.label
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure()]
        }
        return headerRegistration
    }()
    
    private let cellRegistration: CellRegistration = {
        let cellRegistration = CellRegistration { (cell, _, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.label
            content.secondaryText = item.value
            cell.contentConfiguration = content
            
        }
        return cellRegistration
    }()
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { [unowned self] section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: PatientsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUi()
        self.configureSubviews()
        self.configureConstraints()
        self.bindViewModel()
        self.viewModel.onShouldLoadData.send()
    }
    
    // MARK: - Configuration
    
    private func configureUi() {
        self.navigationItem.title = "Patients"
        self.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "arrow.up.arrow.down"),
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(self.didTapSortButton))
    }
    
    @objc
    private func didTapSortButton() {
        self.sortingPickerView.show()
    }
    
    private func configureSubviews() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.stateView)
        self.view.addSubview(self.sortingPickerView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            self.stateView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stateView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.stateView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.stateView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.sortingPickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.sortingPickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.sortingPickerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.sortingPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        
        self.viewModel.$viewState
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                guard let self else { return }
                self.viewStateDidUpdate(newState)
            }
            .store(in: &self.bag)
        
        self.viewModel.$patients
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPatients in
                guard let self else { return }
                self.applySnapshot(with: newPatients)
            }
            .store(in: &self.bag)
        
    }
    
    // MARK: - Actions
    
    private func viewStateDidUpdate(_ newState: ViewState) {
        switch newState {
        case .loading:
            self.stateView.show(with: .activityIndicator)
        case let .error(text):
            self.stateView.show(with: .message(text))
        case .done:
            self.stateView.hide()
        }
    }
    
    private func applySnapshot(with sections: [Patient], _ animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        self.dataSource.apply(snapshot, animatingDifferences: false)
        for section in sections {
            var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<Item> = .init()
            let headerItem = Item(label: section.lastName + " " + section.firstName, value: nil)
            sectionSnapshot.append([headerItem])
            sectionSnapshot.append(section.properties.map { .init(label: $0.label, value: $0.value) }, to: headerItem)
            sectionSnapshot.expand([headerItem])
            self.dataSource.apply(sectionSnapshot, to: section)
        }
    }
    
    private func applyCurrentSnapshot(with sortField: SortField, and sortDirection: SortDirection, _ animated: Bool = true) {
        let sections = self.dataSource.snapshot().sectionIdentifiers
        let sortedSections = sections.sorted(by: sortField.rowProperty.keyPath, isAscending: sortDirection == .asc)
        var snapshot = Snapshot()
        snapshot.appendSections(sortedSections)
        self.dataSource.apply(snapshot, animatingDifferences: false)
        for section in sortedSections {
            var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<Item> = .init()
            let headerItem = Item(label: section.lastName + " " + section.firstName, value: nil)
            sectionSnapshot.append([headerItem])
            sectionSnapshot.append(section.properties.map { .init(label: $0.label, value: $0.value) }, to: headerItem)
            sectionSnapshot.expand([headerItem])
            self.dataSource.apply(sectionSnapshot, to: section)
        }
    }
    
}
