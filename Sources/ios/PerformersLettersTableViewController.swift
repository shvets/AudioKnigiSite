import UIKit
import SwiftSoup
import WebAPI
import TVSetKit

class PerformersLettersTableViewController: UITableViewController {
  static let SegueIdentifier = "Performers Letters"

  let CellIdentifier = "PerformersLetterTableCell"

  var adapter = AudioKnigiServiceAdapter(mobile: true)

  let localizer = Localizer(AudioKnigiServiceAdapter.BundleId, bundleClass: AudioKnigiSite.self)

  private var items: Items!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    items = Items() {
      return try self.adapter.load()
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
    if let view = tableView.cellForRow(at: indexPath),
       let indexPath = tableView.indexPath(for: view) {
      let mediaItem = items.getItem(for: indexPath)

      let letter = mediaItem.name

      if letter == "Все" {
        performSegue(withIdentifier: PerformersTableViewController.SegueIdentifier, sender: view)
      } else {
        performSegue(withIdentifier: PerformersLetterGroupsTableViewController.SegueIdentifier, sender: view)
      }
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case PerformersTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? PerformersTableViewController {
            let adapter = AudioKnigiServiceAdapter(mobile: true)
            adapter.pageLoader.enablePagination()
            adapter.pageLoader.pageSize = 30
            adapter.pageLoader.rowSize = 1

            adapter.params["requestType"] = "All Performers"
            destination.adapter = adapter
          }

        case PerformersLetterGroupsTableViewController.SegueIdentifier:
          if let destination = segue.destination as? PerformersLetterGroupsTableViewController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            let mediaItem = items.getItem(for: indexPath)

            let adapter = AudioKnigiServiceAdapter(mobile: true)
            adapter.params["requestType"] = "Performers Letter Groups"
            adapter.params["parentId"] = mediaItem.name
            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
