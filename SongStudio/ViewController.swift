//
//  ViewController.swift
//  SongStudio
//
//  Created by Karthi on 17/11/19.
//  Copyright © 2019 Karthi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var songs = [SongList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://starlord.hackerearth.com/studio")
        let urlRequest = URLRequest(url: url!)
        ApiService.getSongs(urlRequest: urlRequest, resultStruct: [SongList].self) { (songs, error) in
            self.songs = songs as? [SongList] ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SSPlayerViewController, let index = sender as? Int {
            destVC.songList = songs
            destVC.trackName = songs[index].song
            destVC.trackArtists = songs[index].artists
            destVC.trackImage = songs[index].songImage
            destVC.selectedIndex = index
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SSListCell else {
            return UITableViewCell()
        }
        let songViewModel = ViewModel()
        songViewModel.song = songs[indexPath.row]
        listCell.songTitle.text = songViewModel.songTitle
        listCell.songArtists.text = songViewModel.artistTitle
        songViewModel.song?.getSongImage(url: URL(string: songViewModel.coverImageUrl), completion: { (songImage, error) in
            DispatchQueue.main.async {
                listCell.songImageView.image = songImage
            }
        })
        songViewModel.song?.getAudio(url: URL(string: songViewModel.songUrl))
        return listCell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SegueToPlayer", sender: indexPath.row)
    }
}
