//
//  SongFactory.swift
//  SongsTests
//
//  Created by Dushyant Singh on 17/3/22.
//

import Foundation
@testable import Songs

struct SongFactory {
    static let songs = [Song(id: "1",
                             name: "Song 1",
                             audioURL: "www.google.com",
                             songStatus: .availableToDownload),
                        Song(id: "2",
                             name: "Song 2",
                             audioURL: "www.google2.com",
                             songStatus: .availableToDownload),
                        Song(id: "3",
                             name: "Song 3",
                             audioURL: "www.google3.com",
                             songStatus: .availableToDownload)]
}
