import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class AudioKnigiServiceAdapter: ServiceAdapter {
  let service = AudioKnigiService.shared

  static let bookmarksFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-bookmarks.json"
  static let historyFileName = NSHomeDirectory() + "/Library/Caches/audioknigi-history.json"

  override open class var StoryboardId: String { return "AudioKnigi" }
  override open class var BundleId: String { return "com.rubikon.AudioKnigiSite" }

  lazy var bookmarks = Bookmarks(bookmarksFileName)
  lazy var history = History(historyFileName)

  public override init(mobile: Bool=false) {
    super.init(mobile: mobile)

    bookmarks.load()
    history.load()

    pageSize = 12
    rowSize = 6
  }

  override open func clone() -> ServiceAdapter {
    let cloned = AudioKnigiServiceAdapter(mobile: mobile!)

    cloned.clear()

    return cloned
  }

  override func load() throws -> [MediaItem] {
    let dataSource = AudioKnigiDataSource()

    var params = RequestParams()

    params.identifier = requestType == "Search" ? query : parentId
    params.bookmarks = bookmarks
    params.history = history
    params.selectedItem = selectedItem

    if let requestType = requestType {
      return try dataSource.load(requestType, params: params, pageSize: pageSize!, currentPage: currentPage)
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
