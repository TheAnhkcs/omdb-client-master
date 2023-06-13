//
//  DetailViewController.swift
//  OMDBClient
//
//  Created by duc on 14/07/2021.
//

import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releasedDateLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIView!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var plotLabel: UILabel!
    @IBOutlet private weak var ratedLabel: UILabel!
    @IBOutlet private weak var metascoreLabel: UILabel!
    @IBOutlet private weak var votesLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var writerLabel: UILabel!
    @IBOutlet private weak var actorsLabel: UILabel!
    
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else { return }
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.layoutIfNeeded()
        navigationController.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let navigationController = navigationController else { return }
        
        navigationController.navigationBar.setBackgroundImage(nil, for:.default)
        navigationController.navigationBar.shadowImage = nil
        navigationController.navigationBar.layoutIfNeeded()
    }
}

private extension DetailViewController {
    func configureSubviews() {
    }

    func bindViewModel() {
        let loadTrigger = rx.sentMessage(#selector(viewWillAppear))
            .mapToVoid()
            .take(1)
            .asDriverOnErrorJustComplete()

        let input = DetailViewModel.Input(
            loadTrigger: loadTrigger
        )

        let output = viewModel.transform(input: input)

        output.isLoading
            .drive(onNext: {self.updateUI(with: $0, a: $0)})
            .disposed(by: disposeBag)
        output.movie
            .drive(onNext: populateDetail)
            .disposed(by: disposeBag)
    }
    
    func updateUI(with loadingState: Bool, a: Bool) {
        activityIndicatorView.isHidden = !loadingState
        detailView.isHidden = loadingState
        print(a)
    }
    
    func populateDetail(with movie: Movie) {
        titleLabel.text = movie.title
        releasedDateLabel.text = movie.releasedDate ?? movie.year
        
        genreLabel.text = movie.genre
        durationLabel.text = movie.duration
        ratingLabel.text = movie.rating
        plotLabel.text = movie.plot
        ratedLabel.text = movie.rated
        metascoreLabel.text = movie.metascore
        votesLabel.text = movie.votes
        
        directorLabel.text = movie.director
        writerLabel.text = movie.writer
        actorsLabel.text = movie.actors
    }
}
