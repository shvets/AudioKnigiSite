import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class AuthorsLettersTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "Authors Letters"

  override open var CellIdentifier: String { return "AuthorsLetterTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)
    adapter.disablePagination()
    adapter.requestType = "Authors Letters"
    adapter.parentName = localizer.localize("Authors Letters")
    title = localizer.localize("Letters")

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let letter = mediaItem.name

    if letter == "Все" {
      performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
    else {
      performSegue(withIdentifier: AuthorsLetterGroupTableViewController.SegueIdentifier, sender: view)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "All Authors Letters Group"
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
