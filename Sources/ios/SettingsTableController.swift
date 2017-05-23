import UIKit
import TVSetKit

class SettingsTableController: BaseTableViewController {
  static let SegueIdentifier = "Settings"

  override open var CellIdentifier: String { return "SettingTableCell" }
  override open var BundleId: String { return AudioKnigiServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = AudioKnigiServiceAdapter(mobile: true)

    loadSettingsMenu()
  }

  func loadSettingsMenu() {
    let resetHistory = MediaItem(name: "Reset History")
    let resetQueue = MediaItem(name: "Reset Bookmarks")

    items = [
      resetHistory, resetQueue
    ]
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let settingsMode = mediaItem.name

    if settingsMode == "Reset History" {
      present(buildResetHistoryController(), animated: false, completion: nil)
    }
    else if settingsMode == "Reset Bookmarks" {
      present(buildResetQueueController(), animated: false, completion: nil)
    }
  }

  func buildResetHistoryController() -> UIAlertController {
    let title = localizer.localize("History Will Be Reset")
    let message = localizer.localize("Please Confirm Your Choice")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) {
      let history = (self.adapter as! AudioKnigiServiceAdapter).history

      history.clear()
      history.save()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alertController.addAction(cancelAction)
    alertController.addAction(okAction)

    return alertController
  }

  func buildResetQueueController() -> UIAlertController {
    let title = localizer.localize("Bookmarks Will Be Reset")
    let message = localizer.localize("Please Confirm Your Choice")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) {
      let bookmarks = (self.adapter as! AudioKnigiServiceAdapter).bookmarks

      bookmarks.clear()
      bookmarks.save()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alertController.addAction(cancelAction)
    alertController.addAction(okAction)

    return alertController
  }

}
