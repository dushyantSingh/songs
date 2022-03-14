//
//  SongTableViewCell.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation
import UIKit

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var backgroundContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(songTitle: String) {
        songTitleLabel.text = songTitle
    }
}

private extension SongTableViewCell {
    func setupUI() {
        backgroundContentView.layer.cornerRadius = 5.0
        backgroundContentView.layer.shadowColor = UIColor.black.cgColor
        backgroundContentView.layer.shadowOpacity = 0.2
        backgroundContentView.layer.shadowRadius = 3
        backgroundContentView.layer.shadowOffset = .zero
        backgroundContentView.layer.shouldRasterize = true
        backgroundContentView.layer.rasterizationScale = UIScreen.main.scale

        songTitleLabel.font = Theme.Font.thinFont(with: 18)
    }
}

