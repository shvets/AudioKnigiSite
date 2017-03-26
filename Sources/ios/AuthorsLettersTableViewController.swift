import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class AuthorsLettersTableViewController: BaseTableViewController {
  static let SegueIdentifier = "Authors Letters"

  override open var CellIdentifier: String { return "AuthorsLetterTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    items = AudioKnigiDataSource().getAuthorsLetters()
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let letter = mediaItem.name

    if letter == "Все" {
      performSegue(withIdentifier: AuthorsTableViewController.SegueIdentifier, sender: view)
    }
    else {
      performSegue(withIdentifier: AuthorsLetterGroupTableViewController.SegueIdentifier, sender: view)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case AuthorsTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? AuthorsTableViewController {
            destination.enablePagination()

            let adapter = AudioKnigiServiceAdapter(mobile: true)
            adapter.pageSize = 30
            adapter.rowSize = 1

            adapter.requestType = "All Authors"
            destination.adapter = adapter
          }

        case AuthorsLetterGroupTableViewController.SegueIdentifier:
          if let destination = segue.destination as? AuthorsLetterGroupTableViewController,
             let view = sender as? MediaNameTableCell {

            let mediaItem = getItem(for: view)

            destination.letter = mediaItem.name
          }

        default: break
      }
    }
  }
}
