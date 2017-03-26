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

    DispatchQueue.global().async {
      self.items = AudioKnigiDataSource().getAuthorLetterGroups(self.letter!)

      DispatchQueue.main.async {
        self.tableView?.reloadData()
      }
    }
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: AuthorsInRangeTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case AuthorsInRangeTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? AuthorsInRangeTableViewController,
             let view = sender as? MediaNameTableCell {

            let selectedItem = getItem(for: view) as! AudioKnigiMediaItem

            destination.authors = []

            for item in selectedItem.items {
              destination.authors.append(MediaItem(data: item))
            }
          }

        default: break
      }
    }
  }

}
