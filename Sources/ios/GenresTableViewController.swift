import UIKit
import TVSetKit

class GenresTableViewController: BaseTableViewController {
  static let SegueIdentifier = "Genres"

  override open var CellIdentifier: String { return "GenreTableCell" }

  let service = AudioKnigiService.shared

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    localizer = Localizer(AudioKnigiServiceAdapter.BundleId)

    adapter = AudioKnigiServiceAdapter(mobile: true)

    adapter.requestType = "Genres"
    adapter.parentName = localizer.localize("Genres")
    title = localizer.localize("Genres")

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData() { result in
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

            adapter.requestType = "Books"
            adapter.selectedItem = getItem(for: view)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
