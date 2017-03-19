import UIKit
import SwiftyJSON
import TVSetKit

open class AudioKnigiTableViewController: AudioKnigiBaseTableViewController {
  override open var CellIdentifier: String { return "AudioKnigiTableCell" }

  let MainMenuItems = [
    "BOOKMARKS",
    "HISTORY",
    "New Books",
    "Best Books",
    "Authors",
    "Performers",
    "Genres",
    "SEARCH",
    "SETTINGS"
  ]

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("AudioKnigi")

    adapter = AudioKnigiServiceAdapter(mobile: true)

    self.clearsSelectionOnViewWillAppear = false

    for name in MainMenuItems {
      let item = MediaItem(name: name)

      items.append(item)
    }
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    switch mediaItem.name! {
      case "New Books":
        performSegue(withIdentifier: "NewBooks", sender: view)

      case "Best Books":
        performSegue(withIdentifier: "BestBooks", sender: view)

      case "Authors":
        performSegue(withIdentifier: "Authors", sender: view)

      case "Performers":
        performSegue(withIdentifier: "Performers", sender: view)

      case "Genres":
        performSegue(withIdentifier: "Genres", sender: view)

      case "SETTINGS":
        performSegue(withIdentifier: "Settings", sender: view)

      case "SEARCH":
        performSegue(withIdentifier: SearchTableController.SegueIdentifier, sender: view)

      default:
        performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case "NewBooks":
          if let destination = segue.destination.getActionController() as? NewBooksTableViewController,
             let view = sender as? MediaNameTableCell {

            let mediaItem = getItem(for: view)

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "NewBooks"
            adapter.parentName = localizer.localize(mediaItem.name!)

            destination.adapter = adapter
          }

        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell {

            let mediaItem = getItem(for: view)

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = mediaItem.name
            adapter.parentName = localizer.localize(mediaItem.name!)

            destination.adapter = adapter
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "SEARCH"
            adapter.parentName = localizer.localize("SEARCH_RESULTS")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
