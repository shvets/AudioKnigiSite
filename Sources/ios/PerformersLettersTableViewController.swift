import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class PerformersLettersTableViewController: BaseTableViewController {
  static let SegueIdentifier = "Performers Letters"

  override open var CellIdentifier: String { return "PerformersLetterTableCell" }
  override open var BundleId: String { return AudioKnigiServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let letter = mediaItem.name

    if letter == "Все" {
      performSegue(withIdentifier: PerformersTableViewController.SegueIdentifier, sender: view)
    }
    else {
      performSegue(withIdentifier: PerformersLetterGroupsTableViewController.SegueIdentifier, sender: view)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case PerformersTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? PerformersTableViewController {
            let adapter = AudioKnigiServiceAdapter(mobile: true)
            adapter.pageLoader.enablePagination()
            adapter.pageLoader.pageSize = 30
            adapter.pageLoader.rowSize = 1

            adapter.params.requestType = "All Performers"
            destination.adapter = adapter
          }

        case PerformersLetterGroupsTableViewController.SegueIdentifier:
          if let destination = segue.destination as? PerformersLetterGroupsTableViewController,
             let view = sender as? MediaNameTableCell {

            let mediaItem = getItem(for: view)

            let adapter = AudioKnigiServiceAdapter(mobile: true)
            adapter.params.requestType = "Performers Letter Groups"
            adapter.params.parentId = mediaItem.name
            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
