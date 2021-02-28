//
//  BeerModel.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

struct BeerModel: Codable {
    let id: Int
    let name: String
    let description: String?
    let image_url: String?
    let abv: Double?
    let ibu: Double?
    let tagline: String?
}

struct RequestModel: Encodable {
    let page: Int
    let per_page: Int = 30
    var beer_name: String?
}

struct RepositoryModel: Codable {
    let data: [BeerModel]
    let pages: Int
}
