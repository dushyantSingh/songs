//
//  ViewController.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import UIKit

class SongViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: SongViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        setupUI()
    }

    func reloadView() {
        tableView.reloadData()
    }
}

private extension SongViewController {
    func setupViewModel() {
        viewModel.controller = self
    }

    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Songs"
    }
}

extension SongViewController: UITableViewDataSource {
    func setupTableView() {
        let identifier = "\(SongTableViewCell.self)"
        tableView.register(UINib(nibName: identifier,
                                bundle: Bundle(for: SongTableViewCell.self)),
                          forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(SongTableViewCell.self)"
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: identifier,
                                     for: indexPath) as? SongTableViewCell
        else { return UITableViewCell() }
        let expense = viewModel.songs[indexPath.row]
        configure(cell: cell, song: expense)
        return cell
    }

    func configure(cell: SongTableViewCell, song: Song) {
        cell.configure(songTitle: song.name, status: song.songStatus,
                       onClick: { [weak self] in
            self?.viewModel.songButtonClicked(song)
        })
    }
}
