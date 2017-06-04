import TVSetKit

open class AudioKnigiBaseTableViewController: BaseTableViewController {
  let service = AudioKnigiService.shared

  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer(AudioKnigiServiceAdapter.BundleId, bundleClass: AudioKnigiSite.self)
  }

}
