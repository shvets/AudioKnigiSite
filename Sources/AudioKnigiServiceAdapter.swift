import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class AudioKnigiServiceAdapter: ServiceAdapter {
  static let bookmarksFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-bookmarks.json"
  static let historyFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-history.json"

  override open class var StoryboardId: String { return "AudioKnigi" }
  override open class var BundleId: String { return "com.rubikon.AudioKnigiSite" }

  lazy var bookmarks = Bookmarks(bookmarksFileName)
  lazy var history = History(historyFileName)

  public init(mobile: Bool=false) {
    super.init(dataSource: AudioKnigiDataSource(), mobile: mobile)

    bookmarks.load()
    history.load()

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

  override func load() throws -> [Any] {
    var newPrams = RequestParams()

    newPrams["identifier"] = params["requestType"] as? String == "Search" ? params["query"] as? String : params["parentId"] as? String
    newPrams["bookmarks"] = bookmarks
    newPrams["history"] = history
    newPrams["selectedItem"] = params["selectedItem"]

    if let requestType = params["requestType"] as? String, let dataSource = dataSource {
      return try dataSource.load(requestType, params: newPrams, pageSize: pageLoader.pageSize,
        currentPage: pageLoader.currentPage, convert: true)
    }
    else {
      return []
    }
  }

  override func addBookmark(item: MediaItem) -> Bool {
    return bookmarks.addBookmark(item: item)
  }

  override func removeBookmark(item: MediaItem) -> Bool {
    return bookmarks.removeBookmark(item: item)
  }

  override func addHistoryItem(_ item: MediaItem) {
    history.add(item: item)
  }

}
