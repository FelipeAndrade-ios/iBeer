//
//  BeerItemTableViewCell.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import UIKit

class BeerItemTableViewCell: UITableViewCell {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        // self.layer.sublayers?.removeAll()
    }
    
    func setup(_ model: BeerModel) {
        UIImage.downloadFromRemoteURL(model.image_url, completion: { (image, error) in
            if error == nil {
                self.beerImage.image = image
            }
        })
        titleLabel.text = model.name
        abvLabel.text = String(format: "%.1f %@ ABV", arguments: [model.abv, "%"])
        DispatchQueue.main.async {
            self.setLayer()
        }
        
    }
    
    func setLayer() {
        setBackGroundLayer()
    }
    
    func setBackGroundLayer() {
        let gradientLayer = CAGradientLayer()
        let c: [AnyObject] = [UIColor.red.cgColor, UIColor.red.cgColor, UIColor.white.cgColor]
        gradientLayer.colors = c
        gradientLayer.locations = [0.0, 0.20, 0.35]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = contentView.frame
        // shape.insertSublayer(gradientLayer, at: 0)
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
//        self.contentView.layer.insertSublayer(shape, at: 0)
    }
}
