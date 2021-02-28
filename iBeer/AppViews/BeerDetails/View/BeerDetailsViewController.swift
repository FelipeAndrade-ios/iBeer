//
//  BeerDetailsViewController.swift
//  iBeer
//
//  Created by Felipe Andrade on 25/02/21.
//

import UIKit
import Kingfisher
import Lottie

class BeerDetailsViewController: UIViewController {
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var beerAbv: UILabel!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var beerIBU: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let paragraphSpace = "   "
    let viewModel: BeerDetailsViewModel?
    let backgroundAnimation = AnimationView()
    
    init(viewModel: BeerDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: BeerDetailsViewController.className, bundle: Bundle.currentBundle)
    }
    
    required init?(coder: NSCoder) {
        viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLabels()
        setLottie()
    }
    
    func setupView() {
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.9019607843, alpha: 1)
    }
    
    func setLabels() {
        guard let model = viewModel?.model else { return }
        
        titleLabel.text = model.name
        taglineLabel.text = model.tagline
        
        beerDescription.text = paragraphSpace + (model.description ?? "")
        
        beerAbv.text = viewModel?.getAbv()
        beerIBU.text = viewModel?.getIBU()
        
        beerImage.kf.setImage(with: viewModel?.getImageURL()) { response in
            switch response {
            case .failure:
                self.beerImage.contentMode = .center
                self.beerImage.image = UIImage(systemName: "xmark.icloud")
            case .success:
                self.beerImage.contentMode = .scaleAspectFit
            }
        }
    }
    
    func setLottie() {
        LottieHelper.setLoopAnimation(name: "detailsBackground",
                                      on: lottieView,
                                      animator: backgroundAnimation,
                                      aspectRatio: 16/9)
    }
}
