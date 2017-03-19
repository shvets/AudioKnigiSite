import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class AuthorsLetterGroupTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "AuthorsLetterGroup"

  override open var CellIdentifier: String { return "AuthorsLetterGroupTableCell" }

  var letter: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)
    adapter.requestType = "AuthorsLettersGroup"
    adapter.parentId = letter

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData() { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
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
