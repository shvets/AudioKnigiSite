import UIKit
import TVSetKit
import PageLoader

class AuthorsTableViewController: UITableViewController {
  static let SegueIdentifier = "Authors"
  let CellIdentifier = "AuthorTableCell"

  let localizer = Localizer(AudioKnigiService.BundleId, bundleClass: AudioKnigiSite.self)

  #if os(iOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  #endif
  
  let service = AudioKnigiService()

  let pageLoader = PageLoader()
  
  private var items = Items()

  var requestType: String?
  var selectedItem: Item?
  
  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    #if os(iOS)
      tableView?.backgroundView = activityIndicatorView
      pageLoader.spinner = BaseSpinner(activityIndicatorView)
    #endif
    
    pageLoader.load = {
      var params = Parameters()
      params["requestType"] = self.requestType
      
      if self.requestType == "All Authors" {
        self.pageLoader.enablePagination()
        self.pageLoader.pageSize = self.service.getConfiguration()["authorsPageSize"] as! Int

        params["currentPage"] = self.pageLoader.currentPage
      }
      else {
        params["selectedItem"] = self.selectedItem
      }

      return try self.service.dataSource.load(params: params)
    }
    
    pageLoader.loadData { result in
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
      if pageLoader.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
        pageLoader.loadData { result in
          if let items = result as? [Item] {
            self.items.items += items

            self.tableView?.reloadData()
          }
        }
      }

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
      performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            destination.params["requestType"] = "Author"
            destination.params["selectedItem"] = items.getItem(for: indexPath)

            destination.configuration = service.getConfiguration()
          }

        default: break
      }
    }
  }

}
