import UIKit
import TVSetKit
import PageLoader

class PerformersLetterGroupsTableViewController: UITableViewController {
  static let SegueIdentifier = "Performers Letter Groups"
  let CellIdentifier = "PerformersLetterGroupTableCell"

  let localizer = Localizer(AudioKnigiService.BundleId, bundleClass: AudioKnigiSite.self)

  let service = AudioKnigiService()

  let pageLoader = PageLoader()
  
  private var items = Items()
  
  var parentId: String?
  var letter: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    func load() throws -> [Any] {
      var params = Parameters()
      params["requestType"] = "Performers Letter Groups"

      params["parentId"] = self.parentId
      
      return try self.service.dataSource.load(params: params)
    }

    pageLoader.loadData(onLoad: load) { result in
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
            destination.requestType = "Performers"
          }

        default: break
      }
    }
  }

}
