import UIKit
import TVSetKit

class PerformersTableViewController: BaseTableViewController {
  static let SegueIdentifier = "Performers"

  override open var CellIdentifier: String { return "PerformerTableCell" }
  override open var BundleId: String { return AudioKnigiServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

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

            adapter.params.requestType = "Performer"
            adapter.params.selectedItem = getItem(for: view)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
