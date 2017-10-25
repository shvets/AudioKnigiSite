import TVSetKit
import AudioPlayer

open class AudioKnigiMediaItemsController: MediaItemsController {
  override open func navigate(from view: UICollectionViewCell, playImmediately: Bool = false) {
    if let indexPath = collectionView?.indexPath(for: view),
       let mediaItem = items.getItem(for: indexPath) as? MediaItem {

      if mediaItem.isContainer() {
        if mediaItem.isAudioContainer() {
          performSegue(withIdentifier: AudioItemsController.SegueIdentifier, sender: view)
        }
        else {
          if let destination = MediaItemsController.instantiateController(configuration?["storyboardId"] as! String) {
            destination.configuration = configuration

            for (key, value) in self.params {
              destination.params[key] = value
            }

            destination.params["selectedItem"] = mediaItem
            destination.params["parentId"] = mediaItem.id
            destination.params["parentName"] = mediaItem.name
            //destination.params["isContainer"] = true

            navigationController?.pushViewController(destination, animated: true)
          }
        }
      }
    }
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

            if let requestType = params["requestType"] as? String {
              if requestType != "History" {
                historyManager?.addHistoryItem(mediaItem)
              }
            }

            destination.pageLoader.load = {
              var items: [AudioItem] = []

              var newParams = Parameters()

              for (key, value) in self.params {
                newParams[key] = value
              }

              newParams["requestType"] = "Tracks"
              newParams["selectedItem"] = mediaItem
              //newParams["convert"] = false

              var mediaItems: [Any] = []

              if let data = try self.dataSource?.load(params: newParams) {
                if let mediaItems = data as? [MediaItem] {
                  for mediaItem in mediaItems {
                    let item = mediaItem

                    items.append(AudioItem(name: item.name!, id: item.id!))
                  }
                }
              }

              return items
            }
          }

        default:
          super.prepare(for: segue, sender: sender)
        }
      }
    }
  }

}
