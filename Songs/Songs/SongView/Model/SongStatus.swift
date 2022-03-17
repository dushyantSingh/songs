//
//  SongStatus.swift
//  Songs
//
//  Created by Dushyant Singh on 15/3/22.
//

import Foundation

enum SongStatus {
    case availableToDownload
    case downloading(progress: Float)
    case downloaded
    case playing
    case paused
}

