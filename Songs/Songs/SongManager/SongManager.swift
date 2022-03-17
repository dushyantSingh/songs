//
//  SongDownloader.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation
import AVFoundation

protocol SongManagerType {
    func isDownloaded(_ songId: String) -> Bool
    func deleteSongFromCache(_ songId: String)
    func downloadSong(songId: String,
                      urlString: String,
                      progress: @escaping (Float) -> Void,
                      completionHandler: @escaping (Bool, Error?) -> Void)

    @discardableResult
    func play(_ songId: String) -> Bool
    @discardableResult
    func pause(_ songId: String) -> Bool
    func stop(_ songId: String)
}

class SongManager: NSObject, SongManagerType {
    private struct SongCallBack {
        let id: String
        let progress: (Float) -> Void
        let completion: (Bool, Error?) -> Void
    }

    private var session: URLSession!
    private var tasks = [URLSessionTask: SongCallBack]()
    private var player: AVAudioPlayer?

    override init() {
        super.init()
        session = URLSession(configuration: URLSessionConfiguration.default,
                             delegate: self,
                             delegateQueue: nil)
    }

    func isDownloaded(_ songId: String) -> Bool {
        let path = getSongPath(songId).path
        return FileManager.default.fileExists(atPath: path)
    }

    func downloadSong(songId: String,
                      urlString: String,
                      progress: @escaping (Float) -> Void,
                      completionHandler: @escaping (Bool, Error?) -> Void) {
        guard let remoteURL = URL(string: urlString) else {
            completionHandler(false, nil)
            return
        }

        if isDownloaded(songId) {
            completionHandler(true, nil)
            return
        }

        let task = session.downloadTask(with: remoteURL)
        let songCallBack = SongCallBack(id: songId,
                                        progress: progress,
                                        completion: completionHandler)
        tasks[task] = songCallBack
        task.resume()
    }

    func deleteSongFromCache(_ songId: String) {
        let songPath = getSongPath(songId)
        _ = try? FileManager.default.removeItem(at: songPath)
    }

    @discardableResult
    func play(_ songId: String) -> Bool {
        if player != nil {
            player?.play()
            return true
        }

        do {
            let songPath = getSongPath(songId)
            player = try AVAudioPlayer(contentsOf: songPath)
            player?.prepareToPlay()
            player?.play()
            return true
        } catch {
            print(error)
            player = nil
            return false
        }
    }

    @discardableResult
    func pause(_ songId: String) -> Bool {
        guard let player = player else {
            return false
        }
        player.pause()
        return true
    }

    func stop(_ songId: String) {
        player?.stop()
        player = nil
    }
}


extension SongManager: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let callBack = tasks[downloadTask]
        else { return }
        let targetURL = self.getSongPath(callBack.id)
        do {
            try FileManager.default.createDirectory(atPath: targetURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            _ = try FileManager.default.replaceItemAt(targetURL, withItemAt: location)
            callBack.completion(true, nil)
        }
        catch {
            callBack.completion(false, error)
        }
        tasks.removeValue(forKey: downloadTask)
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        guard let callBack = tasks[task], let error = error else { return }
        callBack.completion(false, error)
        tasks.removeValue(forKey: task)
    }


    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if let callBack = self.tasks[downloadTask] {
            callBack.progress(percentDownloaded)
        }
    }
}

private extension SongManager {
    func getSongPath(_ songId: String) -> URL {
        guard let tempDir = FileManager.default
                .urls(for: .cachesDirectory, in: .userDomainMask).first else {
                    fatalError("Unable to get file path")
                }
        return tempDir.appendingPathComponent("Songs").appendingPathComponent("Song_\(songId).mp3")
    }
}
