import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class AuthorsTableViewController: AudioKnigiBaseTableViewController {
  static let SegueIdentifier = "AuthorsLetterGroup"

  override open var CellIdentifier: String { return "AuthorTableCell" }

  //var document: Document?
  var requestType: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    //adapter = GidOnlineServiceAdapter()

//    do {
//      var data = try service.getAuthors()["movies"] as! [Any]
//
////      if requestType == "Authors" {
////        data = try service.getAuthors()["movies"] as! [Any]
////      }
////      else if requestType == "Performers" {
////        data = try service.getPerformers()["movies"] as! [Any]
////      }
//
//      if data != nil {
//        for item in data! {
//          let elem = item as! [String: Any]
//
//          let id = elem["id"] as! String
//          let name = elem["name"] as! String
//
//          items.append(MediaItem(name: name, id: id))
//        }
//      }
//    }
//    catch {
//      print("Error getting items")
//    }
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
