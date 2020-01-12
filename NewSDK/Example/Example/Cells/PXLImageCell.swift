//
//  PXLImageCell.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import UIKit

class PXLImageCell: UICollectionViewCell {
    static let defaultIdentifier = "ImageCell"

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var otherLabel: UILabel!

    var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: imageView)
            }
            titleLabel.text = viewModel.title
            otherLabel.text = viewModel.actionLinkText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
