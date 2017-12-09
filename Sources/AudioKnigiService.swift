import Foundation
import WebAPI
import TVSetKit
import AudioPlayer

public class AudioKnigiService {
  static let shared: AudioKnigiAPI = {
    return AudioKnigiAPI()
  }()

  static let bookmarksFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-bookmarks.json"
  static let historyFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-history.json"

  static let audioPlayerPropertiesFileName = "audio-knigi-player-settings.json"

  static let StoryboardId = "AudioKnigi"
  static let BundleId = "com.rubikon.AudioKnigiSite"

  static var Authors = shared.getItemsInGroups(bundle!.path(forResource: "authors-in-groups", ofType: "json")!)
  static var Performers = shared.getItemsInGroups(bundle!.path(forResource: "performers-in-groups", ofType: "json")!)

  lazy var bookmarks = Bookmarks(AudioKnigiService.bookmarksFileName)
  lazy var history = History(AudioKnigiService.historyFileName)

  lazy var bookmarksManager = BookmarksManager(bookmarks)
  lazy var historyManager = HistoryManager(history)

  var audioPlayer: AudioPlayer {
    return AudioPlayer.getAudioPlayer(AudioKnigiService.audioPlayerPropertiesFileName)
  }

  var dataSource = AudioKnigiDataSource()

  public init() {}

  static var bundle: Bundle? {
    var bundle: Bundle?

    let podBundle = Bundle(for: AudioKnigiSite.self)

    if let bundleURL = podBundle.url(forResource: AudioKnigiService.BundleId, withExtension: "bundle") {
      bundle = Bundle(url: bundleURL)!
    }

    return bundle
  }

  func getConfiguration() -> [String: Any] {
    return [
      "pageSize": 12,
      "authorsPageSize": 30,
      "performersPageSize": 30,
      "mobile": true,
      "bookmarksManager": bookmarksManager,
      "historyManager": historyManager,
      "dataSource": dataSource,
      "storyboardId": AudioKnigiService.StoryboardId,
      "bundleId": AudioKnigiService.BundleId
    ]
  }
}
