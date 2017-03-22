import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class PerformersLettersTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "Performers Letters"

  override open var CellIdentifier: String { return "PerformersLetterTableCell" }

  var requestType: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)
    adapter.requestType = "Performers Letters"
    adapter.parentName = localizer.localize("Performers Letters")
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
      performSegue(withIdentifier: PerformersLetterGroupTableViewController.SegueIdentifier, sender: view)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case MediaItemsController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? MediaItemsController {

          let adapter = AudioKnigiServiceAdapter(mobile: true)

          adapter.requestType = "All Performers Letters Group"
          destination.adapter = adapter
        }

      case PerformersLetterGroupTableViewController.SegueIdentifier:
        if let destination = segue.destination as? PerformersLetterGroupTableViewController,
           let view = sender as? MediaNameTableCell {

          let mediaItem = getItem(for: view)

          destination.letter = mediaItem.name
        }

      default: break
      }
    }
  }
}
