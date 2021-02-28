//
//  BeerDetailsViewModel.swift
//  iBeer
//
//  Created by Felipe Andrade on 25/02/21.
//

import Foundation

class BeerDetailsViewModel {
    
    let model: BeerModel
    
    init(beerModel: BeerModel) {
        self.model = beerModel
    }
    
    func getImageURL() -> URL? {
        return URL(string: model.image_url ?? "")
    }
    
    func getAbv() -> String {
        if let abv = model.abv {
            return String(format: "%.1f %@ABV", arguments: [abv, "%"])
        }
        return "ABV not informed"
    }
    
    func getIBU() -> String {
        if let ibu = model.ibu {
            return "\(Int(ibu)) IBU"
        }
        return "IBU not informed"
    }
}
