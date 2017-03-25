import UIKit
import SwiftyJSON
import TVSetKit

open class AudioKnigiTableViewController: AudioKnigiBaseTableViewController {
  override open var CellIdentifier: String { return "AudioKnigiTableCell" }

  let MainMenuItems = [
    "Bookmarks",
    "History",
    "New Books",
    "Best Books",
    "Authors",
    "Performers",
    "Genres",
    "Search",
    "Settings"
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
      case "Best Books":
        performSegue(withIdentifier: "Best Books", sender: view)

      case "Authors":
        performSegue(withIdentifier: "Authors Letters", sender: view)

      case "Performers":
        performSegue(withIdentifier: "Performers Letters", sender: view)

      case "Genres":
        performSegue(withIdentifier: "Genres", sender: view)

      case "Settings":
        performSegue(withIdentifier: "Settings", sender: view)

      case "Search":
        performSegue(withIdentifier: SearchTableController.SegueIdentifier, sender: view)

      default:
        performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
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

            adapter.requestType = "Search"
            adapter.parentName = localizer.localize("Search Results")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
