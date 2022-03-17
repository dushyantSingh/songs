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
    let songManager: SongManagerType
    weak var controller: SongViewController?

    private var currentPlayingSong: Song?

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
        self.songManager = songDownloader
        setupSongs()
    }

    func songButtonClicked(_ song: Song) {
        switch song.songStatus {
        case .availableToDownload:
            downloadSong(song)
        case .downloading: break
        case .downloaded, .paused:
                playSong(song)
        case .playing:
            pauseSong(song)
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
                     songStatus: self.songManager.isDownloaded(model.id)
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
}

private extension SongViewModel {
    func downloadSong(_ song: Song) {
        updateSongStatus(song: song, status: .downloading(progress: 0.0))
        songManager.downloadSong(songId: song.id,
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

private extension SongViewModel {
    func playSong(_ song: Song) {
        if let currentSong = currentPlayingSong, currentSong.id != song.id {
            songManager.stop(currentSong.id)
            updateSongStatus(song: currentSong, status: .downloaded)
        }
        if songManager.play(song.id) {
            updateSongStatus(song: song, status: .playing)
            currentPlayingSong = song
        } else {
            showSongPlayError(song)
        }
    }

    func pauseSong(_ song: Song) {
        if songManager.pause(song.id) {
            updateSongStatus(song: song, status: .paused)
        }
    }
}

private extension SongViewModel {
    func showSongPlayError(_ song: Song) {
        let alert = UIAlertController(title: "Unable to play \(song.name)",
                          message: "Please try again",
                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        alert.addAction(UIAlertAction(title: "Redownload",
                                      style: .default, handler: { [weak self]_ in
            self?.songManager.deleteSongFromCache(song.id)
            self?.downloadSong(song)
        }))
        controller?.showErrorAlert(alert)
    }
}
