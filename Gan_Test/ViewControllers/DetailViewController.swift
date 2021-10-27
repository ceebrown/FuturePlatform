//
//  DetailViewController.swift
//  Gan_Test
//
//  Created by Clive Brown on 10/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var occupationLabel: UILabel! {
        didSet {
            occupationLabel.translatesAutoresizingMaskIntoConstraints = false
            occupationLabel.numberOfLines = 0
            occupationLabel.lineBreakMode = .byWordWrapping
        }
    }
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var seasonAppearanceLabel: UILabel! {
        didSet {
            seasonAppearanceLabel.translatesAutoresizingMaskIntoConstraints = false
            seasonAppearanceLabel.numberOfLines = 0
            seasonAppearanceLabel.lineBreakMode = .byWordWrapping
        }
    }
    @IBOutlet weak var pictureImageView: ImageLoader!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .automatic
        configureView()
    }
    
    func configureView() {
        
        if let character = character {
            title = "\(character.name)"
            adjustLargeTitleSize()
            occupationLabel.text = "\(character.occupation?.joined(separator: ", ") ?? "")"
            statusLabel.text = "\(character.status)"
            nickNameLabel.text = "\(character.nickname)"
            seasonAppearanceLabel.text = "\(character.appearance?.map(String.init).joined(separator: ", ") ?? "")"

            let image = character.img
            
            guard let url = URL(string: image) else {
                return
            }

            pictureImageView.loadImageWithUrl(url)
            
            

      }
    }

}
