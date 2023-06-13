//
//  MoviesViewController.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

enum Section {
    case movies
    case loadMore
}

class MoviesViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyView: EmptyView!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.placeholder = Constants.String.enterFilmName
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private var dataSource : UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private let viewModel: MoviesViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MoviesViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        configureDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension MoviesViewController {
    func configureSubviews() {
        title = Constants.String.filmsList
        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let spacing = Constants.Movies.spacing
        collectionView.register(of: MovieCell.self)
        collectionView.register(of: LoadMoreCell.self)
        collectionView.contentInset = UIEdgeInsets(top: spacing,
                                                   left: spacing,
                                                   bottom: spacing,
                                                   right: spacing)
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        
        emptyView.state = .welcome
    }

    func bindViewModel() {
        let appearTrigger = rx.sentMessage(#selector(viewWillAppear)).take(1)
            .map { _ in "" }
            .asDriverOnErrorJustComplete()
        let searchTrigger = rx.sentMessage(#selector(updateSearchResults))
            .compactMap { $0.first as? UISearchController }
            .map { $0.searchBar.text ?? "" }
            .asDriverOnErrorJustComplete()
        let queryChangedTrigger = Driver.merge(appearTrigger, searchTrigger)
        
        let loadMoreTrigger = collectionView.rx.willDisplayCell // tương tự willDisplayCell
            .map { $1.section }
            .filter { [unowned self] section in
                dataSource.snapshot().sectionIdentifiers[section] == .loadMore
            }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        
        
        let toDetailTrigger = collectionView.rx.itemSelected // tương tự didSelectedItem
            .compactMap { [unowned self] indexPath -> Movie? in
                guard let movies = dataSource.snapshot().itemIdentifiers(inSection: .movies) as? [Movie] else {
                    return nil
                }
                
                return movies[indexPath.row]
            }
            .asDriverOnErrorJustComplete()

        let input = MoviesViewModel.Input(
            queryChangedTrigger: queryChangedTrigger,
            loadMoreTrigger: loadMoreTrigger,
            toDetailTrigger: toDetailTrigger
        )
        let output = viewModel.transform(input: input)

        output.snapshot
            .drive(onNext: { [unowned self] snapshot in
                self.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        output.emptyViewState
            .drive(onNext: { [unowned self] state in
                self.emptyView.state = state
            })
            .disposed(by: disposeBag)
        output.reload
            .drive()
            .disposed(by: disposeBag)
        output.loadMore
            .drive()
            .disposed(by: disposeBag)
        output.toDetail
            .drive()
            .disposed(by: disposeBag)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [unowned self]
            collectionView, indexPath, item in
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {// để có thể switch section cần đăng kí private var dataSource : UICollectionViewDiffableDataSource<Section, AnyHashable>!
            case .movies:
                guard let cell = collectionView.dequeueReusableCell(of: MovieCell.self, indexPath: indexPath) else {
                    assertionFailure("Should not happen!")
                    return nil
                }
                if let movie = item as? Movie {
                    cell.configure(with: movie)
                }
                return cell
            case .loadMore:
                return collectionView.dequeueReusableCell(of: LoadMoreCell.self, indexPath: indexPath)
            }
        }
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Movies.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Movies.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource.snapshot().sectionIdentifiers[indexPath.section] {
        case .movies:
            let numberOfSpacing = Constants.Movies.numberOfMoviesPerRow * 2 - 1
            let width = (collectionView.bounds.width - Constants.Movies.spacing * CGFloat(numberOfSpacing)) / CGFloat(Constants.Movies.numberOfMoviesPerRow)
            return CGSize(width: width, height: width / Constants.Movies.cellRatio)
        case .loadMore:
            let width = collectionView.bounds.width - Constants.Movies.spacing * 2
            return CGSize(width: width, height: Constants.Movies.loadMoreCellHeight)
        }
    }
}

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}
