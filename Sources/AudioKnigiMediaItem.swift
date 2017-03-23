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

    self.items = []

    let items = data["items"].arrayValue

    for item in items {
      self.items.append(item)
    }
  }
  
  override func isContainer() -> Bool {
    return type == "book"

    return false
  }

  override func isAudioContainer() -> Bool {
    return true
  }

}
