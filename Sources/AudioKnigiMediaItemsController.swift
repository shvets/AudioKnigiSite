import TVSetKit
import AudioPlayer

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
            destination.name = mediaItem.name
            destination.thumb = mediaItem.thumb
            destination.id = mediaItem.id
            
            if let requestType = params["requestType"] as? String,
               requestType != "History" {
              historyManager?.addHistoryItem(mediaItem)
            }

            if let url = mediaItem.id {
              destination.loadAudioItems = AudioKnigiMediaItemsController.loadAudioItems(url, dataSource: dataSource)
            }
          }
          
        default:
          super.prepare(for: segue, sender: sender)
        }
      }
    }
  }
  
  static func loadAudioItems(_ url: String, dataSource: DataSource?) -> (() throws -> [Any])? {
    return {
      var items: [AudioItem] = []
      
      var params = Parameters()
      
      params["requestType"] = "Tracks"
      params["url"] = url
      
      let semaphore = DispatchSemaphore.init(value: 0)
      
      _ = try dataSource?.load(params: params).map { result in
        for item in result as! [MediaItem] {
          items.append(AudioItem(name: item.name!, id: item.id!))
        }
      }.subscribe(onNext: { result in
        semaphore.signal()
      })
      
      _ = semaphore.wait(timeout: DispatchTime.distantFuture)
      
      return items
    }
  }
  
}

