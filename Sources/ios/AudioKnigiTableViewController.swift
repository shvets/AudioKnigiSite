import UIKit
import SwiftyJSON
import TVSetKit

open class AudioKnigiTableViewController: BaseTableViewController {
  static let SegueIdentifier = "Audio Knigi"

  override open var CellIdentifier: String { return "AudioKnigiTableCell" }
  override open var BundleId: String { return AudioKnigiServiceAdapter.BundleId }

  let MainMenuItems = [
    "Bookmarks",
    "History",
    "New Books",
    "Best Books",
    "Authors",
    "Performers",
    "Genres",
    "Settings",
    "Search"
  ]

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("AudioKnigi")

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
            adapter.pageSize = 20
            adapter.rowSize = 1

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

  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! MediaNameTableCell

    if adapter != nil && adapter.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
      loadMoreData()
    }

    let item = items[indexPath.row]

    cell.configureCell(item: item, localizedName: getLocalizedName(item.name))

    assignImage(cell: cell, name: item.name!)

#if os(tvOS)
    CellHelper.shared.addTapGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))
#endif

    return cell
  }

  func assignImage(cell: UITableViewCell, name: String) {
    switch name {
      case "Bookmarks":
        cell.imageView?.image = UIImage(named: "Star")

      case "History":
        cell.imageView?.image = UIImage(named: "Bookmark")

      case "New Books":
        cell.imageView?.image = UIImage(named: "Book")

      case "Best Books":
        cell.imageView?.image = UIImage(named: "Ok Hand")

      case "Authors":
        cell.imageView?.image = UIImage(named: "Mark Twain")

      case "Performers":
        cell.imageView?.image = UIImage(named: "Microphone")

      case "Genres":
        cell.imageView?.image = UIImage(named: "Comedy")

      case "Settings":
        cell.imageView?.image = UIImage(named: "Engineering")

      case "Search":
        cell.imageView?.image = UIImage(named: "Search")

      default:
        cell.imageView?.image = nil
    }
  }
}

