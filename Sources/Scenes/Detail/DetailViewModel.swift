//
//  DetailViewModel.swift
//  OMDBClient
//
//  Created by duc on 14/07/2021.
//

import RxCocoa

final class DetailViewModel: ViewModelType {
    private let useCase: DetailUseCase
    private let movie: Movie

    init(useCase: DetailUseCase, movie: Movie) {
        self.useCase = useCase
        self.movie = movie

    }
    
    func transform(input: Input) -> Output {
        let loadingIndicator = ActivityIndicator()

        let movie = input.loadTrigger
            .flatMapLatest {
                self.useCase.fetchMovieDetail(with: self.movie.id)
                    .trackActivity(loadingIndicator) // gửi true và false ngược lại cho behavior của class activityIndicator và update cho loadingIndicator output
                    .asDriver(onErrorJustReturn: self.movie) // nếu fetch lỗi thì sẽ trả về self.movie, nếu ko thì trả về result đã asDriver
                    
            }
            .startWith(self.movie) // có nghĩa sẽ gửi movie rỗng từ self.movie chỉ có tên, id mà ko có detail movie cho output updateui sau đó khi fetch xong sẽ gửi movie detail cho output, nếu lỗi thì lại gửi self.movie // giống place holder

        return Output(
            isLoading: loadingIndicator.asDriver(),
            movie: movie
        )
    }
}

extension DetailViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let movie: Driver<Movie>
    }
}
