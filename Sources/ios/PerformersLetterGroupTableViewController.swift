import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class PerformersLetterGroupTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "Performers Letters Group"

  override open var CellIdentifier: String { return "PerformersLetterGroupTableCell" }

  var letter: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)
    adapter.requestType = "Performers Letters Group"
    adapter.parentId = letter

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: PerformersInRangeTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case PerformersInRangeTableViewController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? PerformersInRangeTableViewController,
           let view = sender as? MediaNameTableCell {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "Performers In Range"
            adapter.selectedItem = getItem(for: view)

          destination.adapter = adapter
        }

      default: break
      }
    }
  }

}
