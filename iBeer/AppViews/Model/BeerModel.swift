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
    let first_brewed: String?
    let description: String
    let image_url: String
    let abv: Double
    let ibu: Double?
    let ph: Double?
    let brewers_tips: String
}
