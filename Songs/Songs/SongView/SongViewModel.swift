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

    var songs = [Song]() {
        didSet {
            DispatchQueue.main.async {
                self.controller?.reloadView()
            }
        }
    }

    init(service: SongServiceType) {
        songService = service
        setupSongs()
    }

    func songButtonClicked(_ song: Song) {
        print(song)
    }
}

extension SongViewModel {
    func setupSongs() {
        songService.fetchSongs { [weak self] songModel in
            self?.songs = songModel.map { model in
                Song(id: model.id,
                     name: model.name,
                     audioURL: model.audioURL,
                     songStatus: SongStatus.availableToDownload)
            }
        }
    }
}
