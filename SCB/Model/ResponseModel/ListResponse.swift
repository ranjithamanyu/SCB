//
//  ListResponse.swift
//  SCB
//
//  Created by Mac on 02/04/22.
//

import Foundation

// MARK: - ListResponse
struct ListResponse: Codable {
    let search: [ListResponseSearch]?
    let totalResults, response: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

// MARK: - ListResponseSearch
struct ListResponseSearch: Codable {
    let title, year, imdbID: String?
    let type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
