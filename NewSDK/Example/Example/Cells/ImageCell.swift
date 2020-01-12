//
//  ImageCell.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import UIKit
class ImageCell: UITableViewCell {
    var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: mainImageView)
            }
            titleLabel.text = viewModel.title
            otherLabel.text = viewModel.actionLinkText
        }
    }

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var otherLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
