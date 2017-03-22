import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class AuthorsLetterGroupTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "Authors Letters Group"

  override open var CellIdentifier: String { return "AuthorsLetterGroupTableCell" }

  var letter: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)
    adapter.requestType = "Authors Letters Group"
    adapter.parentId = letter

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: BooksTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case BooksTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? BooksTableViewController,
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
