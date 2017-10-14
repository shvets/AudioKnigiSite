import Foundation
import WebAPI

public class AudioKnigiService {

  static let shared: AudioKnigiAPI = {
    return AudioKnigiAPI()
  }()

  static var bundle: Bundle? {
    var bundle: Bundle?

    let podBundle = Bundle(for: AudioKnigiSite.self)

    if let bundleURL = podBundle.url(forResource: AudioKnigiServiceAdapter.BundleId, withExtension: "bundle") {
      bundle = Bundle(url: bundleURL)!
    }

    return bundle
  }

  static var Authors = shared.getItemsInGroups(bundle!.path(forResource: "authors-in-groups", ofType: "json")!)
  static var Performers = shared.getItemsInGroups(bundle!.path(forResource: "performers-in-groups", ofType: "json")!)
}
