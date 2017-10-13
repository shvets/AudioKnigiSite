import UIKit
import SwiftSoup
import WebAPI
import TVSetKit

class PerformersLetterGroupsTableViewController: UITableViewController {
  static let SegueIdentifier = "Performers Letter Groups"
  let CellIdentifier = "PerformersLetterGroupTableCell"

  let localizer = Localizer(AudioKnigiServiceAdapter.BundleId, bundleClass: AudioKnigiSite.self)

  var parentId: String?

  var letter: String?

  private var items: Items!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    items = Items() {
      let adapter = AudioKnigiServiceAdapter(mobile: true)
      adapter.params["requestType"] = "Performers Letter Groups"
      adapter.params["parentId"] = self.parentId

      return try adapter.load()
    }

    items.loadInitialData(tableView)
  }

// MARK: UITableViewDataSource

  override open func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? MediaNameTableCell {
      let item = items[indexPath.row]

      cell.configureCell(item: item, localizedName: localizer.getLocalizedName(item.name))

      return cell
    }
    else {
      return UITableViewCell()
    }
  }

  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let view = tableView.cellForRow(at: indexPath) {
      performSegue(withIdentifier: PerformersTableViewController.SegueIdentifier, sender: view)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case PerformersTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? PerformersTableViewController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            destination.selectedItem = items.getItem(for: indexPath)
          }

        default: break
      }
    }
  }

}
