import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class AuthorsLetterGroupTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "AuthorsLetterGroup"

  override open var CellIdentifier: String { return "AuthorsLetterGroupTableCell" }

  var requestType: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    let letter = adapter.parentId

    do {
      if letter == "Все" {
        var data = try service.getAuthors()["movies"] as! [Any]
      }
      else {
        for (groupName, group) in AudioKnigiService.Authors {
          if groupName[groupName.startIndex] == letter![groupName.startIndex] {
            items.append(MediaItem(name: groupName, id: groupName))
          }
        }
      }
    }
    catch {
      print("Error getting items")
    }
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell {

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.requestType = "MOVIES"
            adapter.selectedItem = getItem(for: view)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
