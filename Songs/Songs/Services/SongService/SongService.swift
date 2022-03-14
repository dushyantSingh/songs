//
//  SongService.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation

struct SongResponse: Decodable {
    let data: [SongModel]
}

protocol SongServiceType {
    func fetchSongs(completionHandler: @escaping ([SongModel]) -> Void)
}

class SongService: SongServiceType {
    private let baseURL = URL(string: Environment.baseURLString)!

    func fetchSongs(completionHandler: @escaping ([SongModel]) -> Void) {
        var request = URLRequest(url: baseURL)
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
            let songResponse = try? JSONDecoder().decode(SongResponse.self,
                                                    from: data) else {
                completionHandler([])
                return
            }
            completionHandler(songResponse.data)

        }
        .resume()
    }
}
