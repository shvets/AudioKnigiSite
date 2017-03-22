import UIKit
import TVSetKit

class NewBooksTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "New Books"

  override open var CellIdentifier: String { return "NewBookTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)

    adapter.requestType = "New Books"
    adapter.parentName = localizer.localize("New Books")
    title = localizer.localize("New Books")

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData()
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

            adapter.requestType = "New Books"
            adapter.selectedItem = getItem(for: view)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
