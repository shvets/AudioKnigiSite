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
    performSegue(withIdentifier: AuthorTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case AuthorTableViewController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? AuthorTableViewController,
           let view = sender as? MediaNameTableCell {

          //let mediaItem = getItem(for: view)

          //destination.items = items
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
