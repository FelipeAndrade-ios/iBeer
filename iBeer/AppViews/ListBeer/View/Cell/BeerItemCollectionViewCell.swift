//
//  BeerItemCollectionViewCell.swift
//  iBeer
//
//  Created by Felipe Andrade on 23/02/21.
//

import UIKit
import Kingfisher

class BeerItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerTitle: UILabel!
    @IBOutlet weak var beerAbv: UILabel!
    @IBOutlet weak var lottieView: UIView!
    
    override func prepareForReuse() {
        self.beerImage.image = nil
    }
    
    func setup(_ model: BeerModel) {
        let url = URL(string: model.image_url ?? "")
        beerImage.kf.indicatorType = .activity
        beerImage.kf.setImage(with: url, placeholder: nil) { result in
            switch result {
            case .success:
                self.beerImage.contentMode = .scaleAspectFit
            case .failure:
                self.beerImage.contentMode = .center
                self.beerImage.image = UIImage(systemName: "xmark.icloud")
            }
        }
        beerTitle.text = model.name
        beerAbv.text = beerAbv.text == nil ? "" : String(format: "%.1f %@ABV", arguments: [model.abv ?? "", "%"])
    }
}
