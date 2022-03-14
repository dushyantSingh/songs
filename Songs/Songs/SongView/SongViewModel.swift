//
//  SongViewModel.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation

class SongViewModel {
    var songs = [SongModel]()
    let songService: SongServiceType
    init(service: SongServiceType) {
        songService = service
        setupSongs()
    }
}

extension SongViewModel {
    func setupSongs() {
        songService.fetchSongs { [weak self] songModel in
            self?.songs = songModel
        }
    }
}
