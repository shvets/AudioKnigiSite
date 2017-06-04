import UIKit
import TVSetKit

class GenresTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "Genres"

  override open var CellIdentifier: String { return "GenreTableCell" }
  override open var BundleId: String { return AudioKnigiServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("Genres")

    tableView?.backgroundView = activityIndicatorView

    adapter.pageLoader.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.params["requestType"] = "Genre Books"
            adapter.params["selectedItem"] = getItem(for: view)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
