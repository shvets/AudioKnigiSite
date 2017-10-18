import UIKit
import TVSetKit

open class AudioKnigiTableViewController: UITableViewController {
  static let SegueIdentifier = "Audio Knigi"
  let CellIdentifier = "AudioKnigiTableCell"

  let localizer = Localizer(AudioKnigiServiceAdapter.BundleId, bundleClass: AudioKnigiSite.self)

  private var items = Items()

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("AudioKnigi")

    items.pageLoader.load = {
      return self.loadData()
    }

    items.loadInitialData(tableView)
  }

  func loadData() -> [Item] {
    return [
      MediaName(name: "Bookmarks", imageName: "Star"),
      MediaName(name: "History", imageName: "Bookmark"),
      MediaName(name: "New Books", imageName: "Book"),
      MediaName(name: "Best Books", imageName: "Ok Hand"),
      MediaName(name: "Authors", imageName: "Mark Twain"),
      MediaName(name: "Performers", imageName: "Microphone"),
      MediaName(name: "Genres", imageName: "Comedy"),
      MediaName(name: "Settings", imageName: "Engineering"),
      MediaName(name: "Search", imageName: "Search")
    ]
  }

 // MARK: UITableViewDataSource

  override open func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? MediaNameTableCell {
      let item = items[indexPath.row]

      cell.configureCell(item: item, localizedName: localizer.getLocalizedName(item.name))

      return cell
    }
    else {
      return UITableViewCell()
    }
  }

  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let view = tableView.cellForRow(at: indexPath),
       let indexPath = tableView.indexPath(for: view) {
      let mediaItem = items.getItem(for: indexPath)

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
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            let mediaItem = items.getItem(for: indexPath)

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            destination.params["requestType"] = mediaItem.name
            destination.params["parentName"] = localizer.localize(mediaItem.name!)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            destination.params["requestType"] = "Search"
            destination.params["parentName"] = localizer.localize("Search Results")

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        default: break
      }
    }
  }

}
