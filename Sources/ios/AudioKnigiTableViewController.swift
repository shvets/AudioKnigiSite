import UIKit
import SwiftyJSON
import TVSetKit

open class AudioKnigiTableViewController: BaseTableViewController {
  static let SegueIdentifier = "Audio Knigi"

  override open var CellIdentifier: String { return "AudioKnigiTableCell" }
  override open var BundleId: String { return AudioKnigiServiceAdapter.BundleId }

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("AudioKnigi")

    self.clearsSelectionOnViewWillAppear = false

    loadData()
  }

  func loadData() {
    items.append(MediaItem(name: "Bookmarks", imageName: "Star"))
    items.append(MediaItem(name: "History", imageName: "Bookmark"))
    items.append(MediaItem(name: "New Books", imageName: "Book"))
    items.append(MediaItem(name: "Best Books", imageName: "Ok Hand"))
    items.append(MediaItem(name: "Authors", imageName: "Mark Twain"))
    items.append(MediaItem(name: "Performers", imageName: "Microphone"))
    items.append(MediaItem(name: "Genres", imageName: "Comedy"))
    items.append(MediaItem(name: "Settings", imageName: "Engineering"))
    items.append(MediaItem(name: "Search", imageName: "Search"))
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
        case AuthorsLettersTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? AuthorsLettersTableViewController {
            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "Authors Letters"
            destination.adapter = adapter
          }

        case PerformersLettersTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? PerformersLettersTableViewController {
            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "Performers Letters"
            destination.adapter = adapter
          }

        case GenresTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? GenresTableViewController {
            let adapter = AudioKnigiServiceAdapter(mobile: true)
            adapter.enablePagination()
            adapter.pageLoader.pageSize = 20
            adapter.pageLoader.rowSize = 1

            adapter.requestType = "Genres"
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

            adapter.requestType = "Search"
            adapter.parentName = localizer.localize("Search Results")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}

