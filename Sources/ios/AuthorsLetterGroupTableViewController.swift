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
    performSegue(withIdentifier: AuthorsTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case AuthorsTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? AuthorsTableViewController,
             let view = sender as? MediaNameTableCell {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "Group Authors"
            adapter.selectedItem = getItem(for: view)
            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
