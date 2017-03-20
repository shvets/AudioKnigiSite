import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class AuthorsLettersTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "AuthorsLetters"

  override open var CellIdentifier: String { return "AuthorsLetterTableCell" }

  var requestType: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)
    adapter.requestType = "AuthorsLetters"
    adapter.parentName = localizer.localize("Authors Letters")

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData() { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: AuthorsLetterGroupTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
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
