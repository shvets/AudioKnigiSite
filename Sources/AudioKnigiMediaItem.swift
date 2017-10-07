import UIKit
import WebAPI
import TVSetKit

class AudioKnigiMediaItem: MediaItem {
  var items = [[String: String]]()

  required convenience init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  override func isContainer() -> Bool {
    return type == "book" || type == "tracks"
  }

  override func isAudioContainer() -> Bool {
    return true
  }

}
