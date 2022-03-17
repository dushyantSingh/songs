//
//  SongServiceMock.swift
//  SongsTests
//
//  Created by Dushyant Singh on 17/3/22.
//

import Foundation
@testable import Songs

class SongServiceMock: SongServiceType {
    func fetchSongs(completionHandler: @escaping ([SongModel]) -> Void) {
        completionHandler([])
    }
}
