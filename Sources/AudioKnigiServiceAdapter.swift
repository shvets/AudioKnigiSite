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

  func load() throws -> [Any] {
    if let requestType = params["requestType"] as? String,
       let dataSource = dataSource {
      var newParams = RequestParams()

      newParams["requestType"] = requestType
      newParams["identifier"] = requestType == "Search" ? params["query"] as? String : params["parentId"] as? String
      newParams["bookmarks"] = bookmarks
      newParams["history"] = history
      newParams["selectedItem"] = params["selectedItem"]
      newParams["pageSize"] = pageLoader.pageSize
      newParams["currentPage"] = pageLoader.currentPage

      return try dataSource.load(params: newParams)
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
