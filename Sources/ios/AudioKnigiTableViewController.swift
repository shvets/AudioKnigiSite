import UIKit
import TVSetKit
import PageLoader
import AudioPlayer

open class AudioKnigiTableViewController: UITableViewController {
  static let SegueIdentifier = "Audio Knigi"
  let CellIdentifier = "AudioKnigiTableCell"

  let localizer = Localizer(AudioKnigiService.BundleId, bundleClass: AudioKnigiSite.self)

  let service = AudioKnigiService()

  let pageLoader = PageLoader()

  private var items = Items()

  let bookCellConfigurator = CellConfigurator<MenuItem>(
    titleKeyPath: \.name,
    imageKeyPath: \.imageName
  )

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("AudioKnigi")

    pageLoader.loadData(onLoad: getMainMenu) { result in
      if let items = result as? [Item] {
        self.items.items = items

        self.tableView?.reloadData()
      }
    }
  }

  func getMainMenu() throws -> [Any] {
    return [
      MediaName(name: "Now Listening", imageName: "Now Listening"),
      MediaName(name: "Bookmarks", imageName: "Star"),
      MediaName(name: "History", imageName: "Bookmark"),
      MediaName(name: "New Books", imageName: "Book"),
      MediaName(name: "Best Books", imageName: "Ok Hand"),
      MediaName(name: "Authors", imageName: "Mark Twain"),
      MediaName(name: "Performers", imageName: "Microphone"),
      MediaName(name: "Genres", imageName: "Comedy"),
      MediaName(name: "Settings", imageName: "Engineering"),
      MediaName(name: "Search", imageName: "Search")
    ]
  }

  // MARK: UITableViewDataSource

  override open func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? MediaNameTableCell,
       let item = items[indexPath.row] as? MediaName {

      let menuItem = MenuItem(name: item.name!, imageName: item.imageName)

      bookCellConfigurator.configure(cell, for: menuItem, localizer: localizer)

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

      switch mediaItem.name! {
        case "Now Listening":
          performSegue(withIdentifier: "Now Listening", sender: view)

        case "Best Books":
          performSegue(withIdentifier: "Best Books", sender: view)

        case "Authors":
          performSegue(withIdentifier: "Authors Letters", sender: view)

        case "Performers":
          performSegue(withIdentifier: "Performers Letters", sender: view)

        case "Genres":
          performSegue(withIdentifier: "Genres", sender: view)

        case "Settings":
          performSegue(withIdentifier: "Settings", sender: view)

        case "Search":
          performSegue(withIdentifier: SearchTableController.SegueIdentifier, sender: view)

        default:
          performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
      }
    }
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            let mediaItem = items.getItem(for: indexPath)

            destination.params["requestType"] = mediaItem.name
            destination.params["parentName"] = localizer.localize(mediaItem.name!)

            destination.configuration = service.getConfiguration()
          }

        case "Now Listening":
          if let destination = segue.destination.getActionController() as? AudioItemsController {
            let configuration = service.getConfiguration()

            let playerSettings = AudioPlayer.readSettings(AudioKnigiService.audioPlayerPropertiesFileName)
            destination.playerSettings = playerSettings
            
            if let dataSource = configuration["dataSource"] as? DataSource,
              let selectedBookId = playerSettings.items["selectedBookId"],
              let selectedBookName = playerSettings.items["selectedBookName"],
              let selectedBookThumb = playerSettings.items["selectedBookThumb"],
               !selectedBookId.isEmpty {

              destination.selectedBookId = selectedBookId
              destination.selectedBookName = selectedBookName
              destination.selectedBookThumb = selectedBookThumb
              destination.selectedItemId = Int(playerSettings.items["selectedItemId"]!)
              destination.currentSongPosition = Float(playerSettings.items["currentSongPosition"]!)!
              
              destination.loadAudioItems = AudioKnigiMediaItemsController.loadAudioItems(selectedBookId, dataSource: dataSource)
            }
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {
            destination.params["requestType"] = "Search"
            destination.params["parentName"] = localizer.localize("Search Results")

            destination.configuration = service.getConfiguration()
          }

        default: break
      }
    }
  }

}
