import UIKit
import TVSetKit
import PageLoader

class AuthorsLettersTableViewController: UITableViewController {
  static let SegueIdentifier = "Authors Letters"
  let CellIdentifier = "AuthorsLetterTableCell"

  let localizer = Localizer(AudioKnigiService.BundleId, bundleClass: AudioKnigiSite.self)

  let service = AudioKnigiService()

  var pageLoader = PageLoader()
  
  private var items = Items()

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    func load() throws -> [Any] {
      var params = Parameters()      
      params["requestType"] = "Authors Letters"
      
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
    if let view = tableView.cellForRow(at: indexPath),
       let indexPath = tableView.indexPath(for: view) {
      let mediaItem = items.getItem(for: indexPath)

      let letter = mediaItem.name

      if letter == "Все" {
        performSegue(withIdentifier: AuthorsTableViewController.SegueIdentifier, sender: view)
      } else {
        performSegue(withIdentifier: AuthorsLetterGroupsTableViewController.SegueIdentifier, sender: view)
      }
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case AuthorsTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? AuthorsTableViewController {
            destination.requestType = "All Authors"
          }

        case AuthorsLetterGroupsTableViewController.SegueIdentifier:
          if let destination = segue.destination as? AuthorsLetterGroupsTableViewController,
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
