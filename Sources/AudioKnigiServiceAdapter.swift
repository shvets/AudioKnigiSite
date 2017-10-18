import UIKit
import WebAPI
import TVSetKit

class AudioKnigiServiceAdapter: ServiceAdapter {
  static let bookmarksFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-bookmarks.json"
  static let historyFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-history.json"

  override open class var StoryboardId: String { return "AudioKnigi" }
  //override open class var BundleId: String { return "com.rubikon.AudioKnigiSite" }

  lazy var bookmarks = Bookmarks(AudioKnigiServiceAdapter.bookmarksFileName)
  lazy var history = History(AudioKnigiServiceAdapter.historyFileName)

  lazy var bookmarksManager = BookmarksManager(bookmarks)
  lazy var historyManager = HistoryManager(history)

  public init(mobile: Bool=false) {
    super.init(dataSource: AudioKnigiDataSource(), mobile: mobile)

    pageLoader.pageSize = 12
    pageLoader.rowSize = 6

    pageLoader.load = {
      return try self.load()
    }
  }

  override open func clone() -> ServiceAdapter {
    let cloned = AudioKnigiServiceAdapter(mobile: mobile!)

    cloned.clear()

    return cloned
  }

  override open func load() throws -> [Any] {
    params["bookmarks"] = bookmarks
    params["history"] = history

    return try super.load()
  }

  func getConfiguration() -> [String: Any] {
    return [
      "pageSize": 12,
      "rowSize": 1,
      "mobile": true,
      "bookmarksManager": bookmarksManager,
      "historyManager": historyManager,
      "dataSource": dataSource,
      "storyboardId": AudioKnigiServiceAdapter.StoryboardId
    ]
  }
}
