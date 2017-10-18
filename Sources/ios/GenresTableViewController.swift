import UIKit
import TVSetKit

class GenresTableViewController: UITableViewController {
  static let SegueIdentifier = "Genres"
 let CellIdentifier = "GenreTableCell"

  let localizer = Localizer(AudioKnigiServiceAdapter.BundleId, bundleClass: AudioKnigiSite.self)

#if os(iOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
#endif

  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("Genres")

    items.pageLoader.load = {
      let adapter = AudioKnigiServiceAdapter(mobile: true)
      adapter.pageLoader.enablePagination()
      adapter.pageLoader.pageSize = 20
      adapter.pageLoader.rowSize = 1

      adapter.params["requestType"] = "Genres"

      return try adapter.load()
    }

    #if os(iOS)
      tableView?.backgroundView = activityIndicatorView
      items.pageLoader.spinner = PlainSpinner(activityIndicatorView)
    #endif
    
    items.loadInitialData(tableView) { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
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

            destination.params["requestType"] = "Genre Books"
            destination.params["selectedItem"] = items.getItem(for: indexPath)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        default: break
      }
    }
  }

}
