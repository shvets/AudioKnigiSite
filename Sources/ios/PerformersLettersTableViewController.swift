import UIKit
import TVSetKit

class PerformersLettersTableViewController: UITableViewController {
  static let SegueIdentifier = "Performers Letters"
  let CellIdentifier = "PerformersLetterTableCell"

  let localizer = Localizer(AudioKnigiService.BundleId, bundleClass: AudioKnigiSite.self)

  let service = AudioKnigiService()

  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    items.pageLoader.load = {
      var params = Parameters()
      params["requestType"] = "Performers Letters"
      
      return try self.service.dataSource.load(params: params)
    }

    items.pageLoader.loadData { result in
      if let items = result as? [Item] {
        self.items.items = items

        self.tableView?.reloadData()
      }
    }
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
            destination.requestType = "All Performers"
          }

        case PerformersLetterGroupsTableViewController.SegueIdentifier:
          if let destination = segue.destination as? PerformersLetterGroupsTableViewController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            let mediaItem = items.getItem(for: indexPath)

            destination.parentId = mediaItem.name
        }

        default: break
      }
    }
  }
}
