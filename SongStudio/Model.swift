//
//  Model.swift
//  SongStudio
//
//  Created by Karthi on 17/11/19.
//  Copyright © 2019 Karthi. All rights reserved.
//

import UIKit

class SongList: Codable {
    var song: String?
    var url: String?
    var artists: String?
    var cover_image: String?
    var songImage: UIImage?
    
    enum CodingKeys: CodingKey {
        case song
        case url
        case artists
        case cover_image
    }
    
    func getSongImage (url: URL?, completion: @escaping (UIImage?, Error?) -> ()) {
        
        if let songImage = songImage {
            completion(songImage, nil)
        } else {
            guard  let url = url else {
                completion(nil, JSONError.urlError(reason: "URL is Emplty"))
                return
            }
            
            URLSession.shared.dataTask(with:url) { (data, response, error) in
                guard let responseData = data else {
                    completion(nil, JSONError.serializationError(reason: "No Data from response"))
                    return
                }
                self.songImage = UIImage(data: responseData)
                
                DispatchQueue.main.async {
                    completion(self.songImage, nil)
                }
                
                }.resume()
        }
        
    }
    
    func getAudio(url: URL?) {
        guard  let url = url else {
            
            return
        }
        
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent+".mp3")
        print(destinationUrl)
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            
            // if the file doesn't exist
        } else {
            
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
        
        
    }
    
}



