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

//  var episodes: [JSON]?
//  var tracks: [JSON]?

  public override init(mobile: Bool=false) {
    super.init(mobile: mobile)

    bookmarks.load()
    history.load()

    pageSize = 12
    rowSize = 6

//    if requestType == "SOUNDTRACKS" || requestType == "SEARCH" {
//      pageSize = 25
//      rowSize = 5
//    }
//    else {
//      pageSize = 24
//      rowSize = 6
//    }
  }

//  override open func clone() -> ServiceAdapter {
//    let cloned = MyHitServiceAdapter(mobile: mobile!)
//
//    cloned.clear()
//
//    return cloned
//  }
//
//  open func instantiateController(controllerId: String) -> UIViewController {
//    return UIViewController.instantiate(
//      controllerId: controllerId,
//      storyboardId: MyHitServiceAdapter.StoryboardId,
//      bundleId: MyHitServiceAdapter.BundleId)
//  }

  override func load() throws -> [MediaItem] {
    let dataSource = AudioKnigiDataSource()

    var params = RequestParams()

    params.identifier = requestType == "SEARCH" ? query : parentId
    params.bookmarks = bookmarks
    params.history = history
    params.selectedItem = selectedItem

    return try dataSource.load(requestType!, params: params, pageSize: pageSize!, currentPage: currentPage)
  }

//  override func buildLayout() -> UICollectionViewFlowLayout? {
//    let layout = UICollectionViewFlowLayout()
//
//    if requestType == "SOUNDTRACKS" || requestType == "SEARCH" {
//      layout.itemSize = CGSize(width: 210*1.3, height: 300*1.3) // 210 x 300
//      layout.sectionInset = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 120.0, right: 40.0)
//      layout.minimumInteritemSpacing = 50.0
//      layout.minimumLineSpacing = 100.0
//    }
//    else {
//      layout.itemSize = CGSize(width: 210*1.2, height: 300*1.2) // 210 x 300
//      layout.sectionInset = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 120.0, right: 40.0)
//      layout.minimumInteritemSpacing = 40.0
//      layout.minimumLineSpacing = 140.0
//    }
//
//    layout.headerReferenceSize = CGSize(width: 500, height: 75)
//
//    return layout
//  }
//
//  override func getDetailsImageFrame() -> CGRect? {
//    return CGRect(x: 40, y: 40, width: 210*2.7, height: 300*2.7)
//  }
//
//  override func getUrl(_ params: [String: Any]) throws -> String {
//    let urls: [String]?
//
//    let id = params["id"] as! String
//
//    let item = params["item"] as! MediaItem
//
//    if item.type == "episode" {
//      urls = try service.getUrls(url: id)
//    }
//    else {
//      urls = try service.getUrls(path: id)
//    }
//
//    return urls![0]
//  }
//
//  override func retrieveExtraInfo(_ item: MediaItem) throws {
//    if item.type == "movie" {
//      let mediaData = try service.getMediaData(pathOrUrl: item.id!)
//
//      var text = ""
//
//      if let intro = mediaData["Продолжительность:"] as? String {
//        text += "\(intro)\n\n"
//      }
//
//      if let genre = mediaData["Жанр:"] as? String {
//        text += "\(genre)\n\n"
//      }
//
//      if let artists = (mediaData["В ролях:"] as? String)?.description {
//        text += "\(artists)\n\n"
//      }
//
//      if let description = mediaData["description"] as? String {
//        text += "\(description)\n\n"
//      }
//
//      item.description = text
//    }
//  }

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
