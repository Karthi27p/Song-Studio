//
//  SSPlayerViewController.swift
//  SongStudio
//
//  Created by Karthi on 17/11/19.
//  Copyright © 2019 Karthi. All rights reserved.
//

import UIKit
import AVFoundation

class SSPlayerViewController: UIViewController {
    
    @IBOutlet weak var artistTitle: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var mp3Player:MP3Player?
    var timer:Timer?
    var selected = false
    var trackName: String?
    var trackImage: UIImage?
    var trackArtists: String?
    var songList: [SongList]?
    var selectedIndex: Int?
    static var currentTrackIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tracks = getTracks(songs: songList!)
        mp3Player = MP3Player(trackName: tracks, currentIndex: selectedIndex!)
        //setupNotificationCenter()
        setTrackName()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mp3Player = nil
    }
    
    func setTrackName() {
        backgroundImageView.image = trackImage
        artistTitle.text = trackArtists
        songTitle.text = trackName
    }
    
    func getTracks(songs: [SongList]) -> [String] {
        var tracks = [String]()
        for song in songs {
            tracks.append(song.url!)
        }
        return tracks
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        selected = !selected
        
        if(selected) {
            mp3Player?.play()
            startTimer()
            playButton.imageView?.image = nil
            playButton.setImage(UIImage(named: "Pause.png"), for: .normal)
            
        } else {
            mp3Player?.pause()
            timer?.invalidate()
            playButton.imageView?.image = nil
            playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        }
    }
    
    
    @IBAction func playNextPressed(_ sender: Any) {
        SSPlayerViewController.currentTrackIndex += 1
        if SSPlayerViewController.currentTrackIndex >= songList!.count {
            SSPlayerViewController.currentTrackIndex = 0
        }
        mp3Player?.nextSong(songFinishedPlaying: false)
        backgroundImageView.image = songList?[SSPlayerViewController.currentTrackIndex].songImage
        playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        artistTitle.text = songList?[SSPlayerViewController.currentTrackIndex].artists
        songTitle.text = songList?[SSPlayerViewController.currentTrackIndex].song
        startTimer()
        selected = false
    }
    
    @IBAction func playPrevPressed(_ sender: Any) {
        SSPlayerViewController.currentTrackIndex -= 1
        if SSPlayerViewController.currentTrackIndex < 0 {
            SSPlayerViewController.currentTrackIndex = songList!.count - 1
        }
        mp3Player?.previousSong()
        startTimer()
        backgroundImageView.image = songList?[SSPlayerViewController.currentTrackIndex].songImage
        artistTitle.text = songList?[SSPlayerViewController.currentTrackIndex].artists
        songTitle.text = songList?[SSPlayerViewController.currentTrackIndex].song
        playButton.setImage(UIImage(named: "Play.png"), for: .normal)
        selected = false
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateViewsWithTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateViewsWithTimer(theTimer: Timer){
        updateViews()
    }
    
    func updateViews(){
        trackTime.text = mp3Player?.getCurrentTimeAsString()
        if let progress = mp3Player?.getProgress() {
            progressView.progress = progress
        }
    }
    
}
