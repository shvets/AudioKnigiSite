import Foundation
import WebAPI

public class AudioKnigiService {

  static let shared: AudioKnigiAPI = {
    return AudioKnigiAPI()
  }()

  static var Authors = shared.getItemsInGroups(Bundle(identifier: AudioKnigiServiceAdapter.BundleId)!.path(forResource: "authors", ofType: "json")!)
  static var Performers = shared.getItemsInGroups(Bundle(identifier: AudioKnigiServiceAdapter.BundleId)!.path(forResource: "performers", ofType: "json")!)

}
