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

    requestType = adapter.requestType

    do {
      let data = try service.getAuthorsLetters()

      for item in data {
        let name = item as! String

//        if !["Ё", "Й", "Щ", "Ъ", "Ы", "Ь"].contains(letter) {
//          items.append(MediaItem(name: letter))
//        }

        items.append(MediaItem(name: name, id: name))
      }
    }
    catch {
      print("Error getting items")
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
             let selectedCell = sender as? MediaNameTableCell {

            let mediaItem = getItem(for: selectedCell)

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            adapter.parentId = mediaItem.name
            //adapter.parentName = localizer.localize(requestType!)

            destination.adapter = adapter
            destination.requestType = requestType
          }

        default: break
      }
    }
  }
}
