//
//  SongViewModel.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation
import UIKit

class SongViewModel {

    let songService: SongServiceType
    let songDownloader: SongManagerType
    weak var controller: SongViewController?

    var songs = [Song]() {
        didSet {
            DispatchQueue.main.async {
                self.controller?.reloadView()
            }
        }
    }

    init(service: SongServiceType,
         songDownloader: SongManagerType) {
        self.songService = service
        self.songDownloader = songDownloader
        setupSongs()
    }

    func songButtonClicked(_ song: Song) {
        if case .availableToDownload = song.songStatus {
            updateSongStatus(song: song, status: .downloading(progress: 0.0))
            songDownloader.downloadSong(id: song.id,
                                        urlString: song.audioURL) { [weak self] progress in
                self?.updateSongStatus(song: song,
                                 status: .downloading(progress: progress))
            } completionHandler: { [weak self] succeeded, error in
                if succeeded {
                    self?.updateSongStatus(song: song,
                                           status: .downloaded)
                } else {
                    if let title = error?.localizedDescription {
                        self?.songDownloadFailed(title)
                    } else {
                        self?.songDownloadFailed("Unable to download song. Please try again")
                    }
                    self?.updateSongStatus(song: song,
                                           status: .availableToDownload)
                }
            }
        }
    }
}

private extension SongViewModel {
    func setupSongs() {
        songService.fetchSongs { [weak self] songModel in
            guard let self = self else { return }
            self.songs = songModel.map { model in
                Song(id: model.id,
                     name: model.name,
                     audioURL: model.audioURL,
                     songStatus: self.songDownloader.isDownloaded(model.id)
                     ? SongStatus.downloaded
                     : SongStatus.availableToDownload)
            }
        }
    }

    func updateSongStatus(song: Song, status: SongStatus) {
        for (index, item) in songs.enumerated() where item.id == song.id {
            let updatedSong = Song(id: item.id,
                                   name: item.name,
                                   audioURL: item.audioURL,
                                   songStatus: status)
            songs[index] = updatedSong
            break
        }
    }

    func songDownloadFailed(_ title: String) {
        let alert = UIAlertController(title: title,
                                      message: "",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .default))
        DispatchQueue.main.async {
            self.controller?.present(alert, animated: true)
        }
    }
}
