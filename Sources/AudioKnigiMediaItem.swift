import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class AudioKnigiMediaItem: MediaItem {
  var items = [JSON]()

  override init(data: JSON) {
    super.init(data: data)

    self.items = []

    let items = data["items"].arrayValue

    for item in items {
      self.items.append(item)
    }
  }
  
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
