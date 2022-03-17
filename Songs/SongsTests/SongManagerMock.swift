//
//  SongManagerMock.swift
//  SongsTests
//
//  Created by Dushyant Singh on 17/3/22.
//

import Foundation
@testable import Songs

class SongManagerMock: SongManagerType {

    func isDownloaded(_ songId: String) -> Bool {
        return false
    }

    func deleteSongFromCache(_ songId: String) {}

    func downloadSong(songId: String,
                      urlString: String,
                      progress: @escaping (Float) -> Void,
                      completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(true, nil)
    }

    func play(_ songId: String) -> Bool {
        return true
    }

    func pause(_ songId: String) -> Bool {
        return true
    }

    func stop(_ songId: String) {}
}
