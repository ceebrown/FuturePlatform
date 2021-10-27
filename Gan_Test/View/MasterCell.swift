//
//  MasterCell.swift
//  Gan_Test
//
//  Created by Clive Brown on 10/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import UIKit

class MasterCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
         didSet {
             titleLabel.translatesAutoresizingMaskIntoConstraints = false
             titleLabel.numberOfLines = 0
             titleLabel.lineBreakMode = .byWordWrapping
             titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
         }
     }
    
    @IBOutlet weak var pictureImageView: ImageLoader! {
        didSet {
            pictureImageView.contentMode = .scaleAspectFit
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(character: Character) {
        titleLabel?.text = character.name
        let image = character.img
        guard let url = URL(string: image) else {
            return
        }
        pictureImageView.loadImageWithUrl(url)
     }
    
    private func showHideView(hidePicture: Bool) {
        pictureImageView.isHidden = hidePicture
    }
    
}
