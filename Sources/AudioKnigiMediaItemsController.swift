import TVSetKit
import AudioPlayer
import MediaApis

open class AudioKnigiMediaItemsController: MediaItemsController {
  override open func navigate(from view: UICollectionViewCell, playImmediately: Bool = false) {
    performSegue(withIdentifier: AudioItemsController.SegueIdentifier, sender: view)
  }

  // MARK: Navigation

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier,
      let selectedCell = sender as? MediaItemCell {

      if let indexPath = collectionView?.indexPath(for: selectedCell) {
        let mediaItem = items[indexPath.row] as! MediaItem

        switch identifier {

        case AudioItemsController.SegueIdentifier:
          if let destination = segue.destination as? AudioItemsController {
            let playerSettings = AudioPlayer.readSettings(AudioKnigiService.audioPlayerPropertiesFileName)

            destination.playerSettings = playerSettings

            destination.selectedBookId = mediaItem.id!
            destination.selectedBookName = mediaItem.name!
            destination.selectedBookThumb = mediaItem.thumb!
            destination.selectedItemId = -1
            destination.requestHeaders = getRequestHeaders()

            if let url = mediaItem.id {
              destination.loadAudioItems = AudioKnigiMediaItemsController.loadAudioItems(url, dataSource: dataSource)
            }

            if let requestType = params["requestType"] as? String, requestType != "History" {
              historyManager?.addHistoryItem(mediaItem)
            }
          }

        default:
          super.prepare(for: segue, sender: sender)
        }
      }
    }
  }
  
  func getRequestHeaders() -> [String: String] {
    var headers: [String : String] = [:]
    
    headers["Referer"] = AudioKnigiAPI.SiteUrl

    return headers
  }

  static func loadAudioItems(_ url: String, dataSource: DataSource?) -> (() throws -> [Any])? {
    return {
      var items: [AudioItem] = []

      var params = Parameters()

      params["requestType"] = "Tracks"
      params["url"] = url

      let result = try dataSource?.load(params: params)

      for item in result as! [MediaItem] {
        items.append(AudioItem(name: item.name!, id: item.id!))
      }

      return items
    }
  }

}

