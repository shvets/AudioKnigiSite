import UIKit
import MediaApis
import TVSetKit

class AudioKnigiMediaItem: MediaItem {
  var items = [AudioKnigiAPI.PersonName]()

  required convenience init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }

}
