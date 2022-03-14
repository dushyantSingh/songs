//
//  SongViewModel.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation

class SongViewModel {
    let songService: SongServiceType
    weak var controller: SongViewController?

    var songs = [SongModel]()

    init(service: SongServiceType) {
        songService = service
        setupSongs()
    }
}

extension SongViewModel {
    func setupSongs() {
        songService.fetchSongs { [weak self] songModel in
            self?.songs = songModel
            DispatchQueue.main.async {
                self?.controller?.reloadView()
            }
        }
    }
}
