//
//  SongModel.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation

struct SongModel: Decodable {
    let id: String
    let name: String
    let audioURL: String
}
