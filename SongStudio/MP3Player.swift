//
//  MP3Player.swift
//  SongStudio
//
//  Created by Karthi on 17/11/19.
//  Copyright © 2019 Karthi. All rights reserved.
//

import UIKit
import AVFoundation

class MP3Player: NSObject, AVAudioPlayerDelegate {
    var player:AVAudioPlayer?
    var tracks:[String] = [String]()
    
    override init(){
        super.init()
    }
    
    init(trackName: [String], currentIndex: Int) {
        tracks = trackName
        SSPlayerViewController.currentTrackIndex = currentIndex
        super.init()
        queueTrack()
    }
    
    
    func queueTrack(){
        if (player != nil) {
            player = nil
        }
        
        guard let url = URL(string: tracks[SSPlayerViewController.currentTrackIndex]) else {
            return
        }  // NSURL.fileURL(withPath: tracks[currentTrackIndex] as String)
        
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent+".mp3")
        
        
        
        do {
            player = try AVAudioPlayer(contentsOf: destinationUrl)
        } catch {
            let alert = UIAlertController(title: "Music Loading....", message: "Please wait while we get your lovely music", preferredStyle: .alert)
            let playerVC = UIApplication.shared.keyWindow?.rootViewController?.children.last
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                playerVC?.navigationController?.popViewController(animated: true)
                NSLog("OK Pressed")
            }
            
            alert.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
            print(error)
        }
        
        
        player?.delegate = self
        player?.prepareToPlay()
        NotificationCenter.default.post(name: Notification.Name("SetTrackNameText"), object: nil)
        
    }
    
    func play() {
        guard let player = player else {
            return
        }
        
        if player.isPlaying == false {
            player.play()
        }
    }
    
    func stop(){
        guard let player = player else {
            return
        }
        if player.isPlaying{
            player.stop()
            player.currentTime = 0
        }
    }
    
    func pause(){
        guard let player = player else {
            return
        }
        if player.isPlaying{
            player.pause()
        }
    }
    
    func nextSong(songFinishedPlaying:Bool){
        
        guard let player = player else {
            return
        }
        
        var playerWasPlaying = false
        if player.isPlaying{
            player.stop()
            playerWasPlaying = true
        }
        
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player.play()
        }
    }
    
    func previousSong(){
        
        guard let player = player else {
            return
        }
        
        var playerWasPlaying = false
        if player.isPlaying {
            player.stop()
            playerWasPlaying = true
        }
        
        
        queueTrack()
        if playerWasPlaying {
            player.play()
        }
    }
    
    func getCurrentTrackName() -> String {
        let trackName = (tracks[SSPlayerViewController.currentTrackIndex] as NSString).lastPathComponent
        return (trackName as NSString).deletingPathExtension as String
    }
    
    func getCurrentTimeAsString() -> String {
        var seconds = 0
        var minutes = 0
        if let time = player?.currentTime {
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    func getProgress()->Float{
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime = player?.currentTime, let duration = player?.duration {
            theCurrentTime = currentTime
            theCurrentDuration = duration
        }
        return Float(theCurrentTime / theCurrentDuration)
    }
    
    func setVolume(volume:Float){
        player?.volume = volume
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag == true {
            nextSong(songFinishedPlaying: true)
        }
    }
}
