//
//  Movie.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import Foundation

struct Movie: Codable {
    let uuid = UUID()
    
    let id: String
    let title: String?
    let year: String?
    let poster: String?
    let releasedDate: String?
    let genre: String?
    let duration: String?
    let rating: String?
    let plot: String?
    let rated: String?
    let metascore: String?
    let votes: String?
    let director: String?
    let writer: String?
    let actors: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case releasedDate = "Released"
        case genre = "Genre"
        case duration = "Runtime"
        case rating = "imdbRating"
        case plot = "Plot"
        case rated = "Rated"
        case metascore = "Metascore"
        case votes = "imdbVotes"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
    }
}

extension Movie: Hashable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
