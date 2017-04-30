import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class PerformersLetterGroupsTableViewController: BaseTableViewController {
  static let SegueIdentifier = "Performers Letter Groups"

  override open var CellIdentifier: String { return "PerformersLetterGroupTableCell" }
  override open var BundleId: String { return AudioKnigiServiceAdapter.BundleId }

  var letter: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: PerformersTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case PerformersTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? PerformersTableViewController,
             let view = sender as? MediaNameTableCell {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.params.requestType = "Performers"
            adapter.params.selectedItem = getItem(for: view)
            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
