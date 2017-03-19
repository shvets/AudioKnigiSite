import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class AudioKnigiMediaItem: MediaItem {
  let service = AudioKnigiService.shared

  var tracks = [JSON]()
  var items = [JSON]()

  override init(data: JSON) {
    super.init(data: data)

//    self.seasonNumber = data["seasonNumber"].stringValue
//    self.episodeNumber = data["episodeNumber"].stringValue
//
//    self.tracks = []
//
//    let tracks = data["tracks"].arrayValue
//
//    for track in tracks {
//      self.tracks.append(track)
//    }
//
//    self.items = []
//
//    let items = data["items"].arrayValue
//
//    for item in items {
//      self.items.append(item)
//    }
  }
  
//  override func isContainer() -> Bool {
//    return type == "serie" || type == "season" || type == "soundtrack" || type == "selection" || type == "tracks"
//  }
//
//  override func isAudioContainer() -> Bool {
//    var result = false
//
//    if type == "soundtrack" {
//      do {
//        let albums = try service.getAlbums(id!)["movies"] as! [Any]
//
//        if albums.count == 1 {
//          result = true
//        }
//      }
//      catch {
//        print("error")
//      }
//    }
//    else if type == "tracks" {
//      result = true
//    }
//
//    return result
//  }
//
//  override func getBitrates() throws -> [[String: Any]] {
//    var bitrates: [[String: Any]] = []
//
//    let urls: [String]?
//
//    if type == "episode" {
//      urls = try service.getUrls(url: id!)
//    }
//    else {
//      urls = try service.getUrls(path: id!)
//    }
//
//    if let urls = urls {
//      for url in urls {
//        let metadata = try service.getMetadata(url)
//
//        let bitrate = metadata["bitrate"]
//
//        if bitrate != nil {
//          bitrates.append(["id": bitrate!])
//        }
//      }
//    }
//
//    let qualityLevels = QualityLevel.availableLevels(bitrates.count)
//
//    var newBitrates: [[String: Any]] = []
//
//    for (index, bitrate) in bitrates.enumerated() {
//      var newBitrate = bitrate
//
//      newBitrate["name"] = qualityLevels[index].rawValue
//
//      newBitrates.append(newBitrate)
//    }
//
//    return newBitrates
//  }

}
