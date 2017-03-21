import TVSetKit

open class AudioKnigiBaseTableViewController: InfiniteTableViewController {
  let service = AudioKnigiService.shared

  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer(AudioKnigiServiceAdapter.BundleId)
  }

}