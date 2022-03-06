//
//  FileDownloader.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 06/03/2022.
//

import Foundation

final class FileDownloader {
    
    class func downloadFile(audioUrl: URL, completion: @escaping ((URL) -> Void)) {
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            
        } else {
            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    DispatchQueue.main.async {
                        completion(destinationUrl)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
    }
}
