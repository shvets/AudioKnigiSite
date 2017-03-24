import UIKit
import TVSetKit

class PerformersInRangeTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "Performers In Range"

  override open var CellIdentifier: String { return "PerformersInRangeTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

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

          adapter.requestType = "Performer"
          adapter.selectedItem = getItem(for: view)

          destination.adapter = adapter
        }

      default: break
      }
    }
  }

}
