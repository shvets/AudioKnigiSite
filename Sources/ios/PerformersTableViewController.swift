import UIKit
import TVSetKit

class PerformersTableViewController: UITableViewController {
  static let SegueIdentifier = "Performers"
  let CellIdentifier = "PerformerTableCell"

  let localizer = Localizer(AudioKnigiServiceAdapter.BundleId, bundleClass: AudioKnigiSite.self)

#if os(iOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
#endif
  
  var requestType: String?
  var selectedItem: Item?

  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    items.pageLoader.load = {
      let adapter = AudioKnigiServiceAdapter(mobile: true)

      if self.requestType == "All Performers" {
        adapter.pageLoader.enablePagination()
        adapter.pageLoader.pageSize = 30
        adapter.pageLoader.rowSize = 1
      }
      else {
        adapter.params["selectedItem"] = self.selectedItem
      }

      adapter.params["requestType"] = self.requestType
      
      return try adapter.load()
    }

    #if os(iOS)
      tableView?.backgroundView = activityIndicatorView
      items.pageLoader.spinner = PlainSpinner(activityIndicatorView)
    #endif
    
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

            let adapter = AudioKnigiServiceAdapter(mobile: true)

            destination.params["requestType"] = "Performer"
            destination.params["selectedItem"] = items.getItem(for: indexPath)

            destination.configuration = adapter.getConfiguration()
          }

        default: break
      }
    }
  }

}
