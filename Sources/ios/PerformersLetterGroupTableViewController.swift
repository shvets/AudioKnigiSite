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

    DispatchQueue.global().async {
      self.items = AudioKnigiDataSource().getPerformerLetterGroups(self.letter!)

      DispatchQueue.main.async {
        self.tableView?.reloadData()
      }
    }
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: PerformersInRangeTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case PerformersInRangeTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? PerformersInRangeTableViewController,
             let view = sender as? MediaNameTableCell {

            let selectedItem = getItem(for: view) as! AudioKnigiMediaItem

            destination.performers = []

            for item in selectedItem.items {
              destination.performers.append(MediaItem(data: JSON(item)))
            }
          }

        default: break
      }
    }
  }

}
