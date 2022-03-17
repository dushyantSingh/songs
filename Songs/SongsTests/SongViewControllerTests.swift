//
//  SongViewControllerTests.swift
//  SongsTests
//
//  Created by Dushyant Singh on 17/3/22.
//

@testable import Songs
import XCTest

class SongViewControllerTests: XCTestCase {
    func getViewController() -> SongViewController {
        let vc = UIStoryboard(name: "SongViewController",
                              bundle: nil)
            .instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
        return vc
    }

    func getViewModel() -> SongViewModel {
        let mockService = SongServiceMock()
        let mockManager = SongManagerMock()
        return SongViewModel(service: mockService,
                             songDownloader: mockManager)
    }

    func test_NumberOfSongs() {
        let viewController = getViewController()
        viewController.viewModel = getViewModel()
        viewController.viewModel.songs = SongFactory.songs
        viewController.loadViewIfNeeded()
        let numberOfSongs = viewController.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfSongs, 3)
    }

    func test_NameOfFirstSong() {
        let viewController = getViewController()
        viewController.viewModel = getViewModel()
        viewController.viewModel.songs = SongFactory.songs
        viewController.loadViewIfNeeded()
        let index = IndexPath(row: 0, section: 0)
        guard let cell = viewController.tableView.cellForRow(at: index) as? SongTableViewCell
        else {
            XCTFail()
            return
        }
        let songName = cell.songTitleLabel.text
        XCTAssertEqual(songName, "Song 1")
    }

    func test_NameOfSecondSong() {
        let viewController = getViewController()
        viewController.viewModel = getViewModel()
        viewController.viewModel.songs = SongFactory.songs
        viewController.loadViewIfNeeded()
        let index = IndexPath(row: 1, section: 0)
        guard let cell = viewController.tableView.cellForRow(at: index) as? SongTableViewCell
        else {
            XCTFail()
            return
        }
        let songName = cell.songTitleLabel.text
        XCTAssertEqual(songName, "Song 2")
    }

    func test_NameOfThirdSong() {
        let viewController = getViewController()
        viewController.viewModel = getViewModel()
        viewController.viewModel.songs = SongFactory.songs
        viewController.loadViewIfNeeded()
        let index = IndexPath(row: 2, section: 0)
        guard let cell = viewController.tableView.cellForRow(at: index) as? SongTableViewCell
        else {
            XCTFail()
            return
        }
        let songName = cell.songTitleLabel.text
        XCTAssertEqual(songName, "Song 3")
    }
}

