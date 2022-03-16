//
//  SongDownloader.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation
protocol SongManagerType {
    func isDownloaded(_ songId: String) -> Bool
    func downloadSong(id: String,
                      urlString: String,
                      progress: @escaping (Float) -> Void,
                      completionHandler: @escaping (Bool, Error?) -> Void)
}

class SongManager: NSObject, SongManagerType {
    private struct SongCallBack {
        let id: String
        let progress: (Float) -> Void
        let completion: (Bool, Error?) -> Void
    }

    private var downloadOperationQueue: OperationQueue!
    private var session: URLSession!
    private var tasks = [URLSessionTask: SongCallBack]()

    override init() {
        super.init()
        downloadOperationQueue = OperationQueue()
        downloadOperationQueue.maxConcurrentOperationCount = 1
        session = URLSession(configuration: URLSessionConfiguration.default,
                             delegate: self,
                             delegateQueue: downloadOperationQueue)
    }

    func isDownloaded(_ songId: String) -> Bool {
        let path = getSongPath(songId).path
        return FileManager.default.fileExists(atPath: path)
    }

    func downloadSong(id: String,
                      urlString: String,
                      progress: @escaping (Float) -> Void,
                      completionHandler: @escaping (Bool, Error?) -> Void) {
        guard let remoteURL = URL(string: urlString) else {
            completionHandler(false, nil)
            return
        }

        if isDownloaded(id) {
            completionHandler(true, nil)
            return
        }

        let task = session.downloadTask(with: remoteURL)
        let songCallBack = SongCallBack(id: id,
                                        progress: progress,
                                        completion: completionHandler)
        tasks[task] = songCallBack
        task.resume()
    }
    var somes: NSKeyValueObservation!
}


extension SongManager: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let callBack = tasks[downloadTask] else { return }

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
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        guard let callBack = tasks[task], let error = error else { return }
        callBack.completion(false, error)
    }


    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            if let callBack = self.tasks[downloadTask] {
                callBack.progress(percentDownloaded)
            }
        }
    }
}

private extension SongManager {
    func getSongPath(_ songId: String) -> URL {
        guard let tempDir = FileManager.default.urls(for: .cachesDirectory,
                                                        in: .userDomainMask).first else {
            fatalError("Unable to get file path")
        }
        return tempDir.appendingPathComponent("Songs").appendingPathComponent("Song_\(songId).mp3")
    }
}
