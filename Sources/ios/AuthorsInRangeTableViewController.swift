import UIKit
import TVSetKit

class AuthorsInRangeTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "Authors In Range"

  override open var CellIdentifier: String { return "AuthorInRangeTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: BooksTableViewController.SegueIdentifier, sender: view)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case BooksTableViewController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? BooksTableViewController,
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