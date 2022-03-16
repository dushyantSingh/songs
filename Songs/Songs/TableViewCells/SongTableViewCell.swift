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
    @IBOutlet weak var songStatusButton: UIButton!
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    var onButtonClick: (() -> Void)?
    func configure(songTitle: String, status: SongStatus, onClick: (() -> Void)?) {
        onButtonClick = onClick
        updateSongStatus(status)
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
        songStatusButton.addTarget(self,
                                   action: #selector(songsButtonClicked),
                                   for: .touchUpInside)
    }

    @objc
    func songsButtonClicked() {
        if let onButtonClick = onButtonClick {
            onButtonClick()
        }
    }

    func updateSongStatus(_ status: SongStatus) {
        songStatusButton.isHidden = false
        loadingView.stopAnimating()
        loadingView.isHidden = true

        switch status {
        case .availableToDownload:
            songStatusButton.setImage(UIImage(systemName: "icloud.and.arrow.down"),
                                      for: .normal)
        case .downloading:
            songStatusButton.isHidden = true
            loadingView.startAnimating()
            loadingView.isHidden = false
        case .downloaded:
            songStatusButton.setImage(UIImage(systemName: "play.circle"),
                                      for: .normal)
        case .playing:
            songStatusButton.setImage(UIImage(systemName: "pause.circle"),
                                      for: .normal)
        case .paused:
            songStatusButton.setImage(UIImage(systemName: "play.circle"),
                                      for: .normal)
        }
    }
}

