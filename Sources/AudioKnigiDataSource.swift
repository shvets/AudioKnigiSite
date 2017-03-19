import SwiftyJSON
import WebAPI
import TVSetKit

class AudioKnigiDataSource: DataSource {
  let service = AudioKnigiService.shared

  func load(_ requestType: String, params: RequestParams, pageSize: Int, currentPage: Int) throws -> [MediaItem] {
    var result: [String: Any] = ["movies": []]

    let identifier = params.identifier
    let bookmarks = params.bookmarks!
    let history = params.history!
    let selectedItem = params.selectedItem as? AudioKnigiMediaItem

//    var tracks = [JSON]()

    var request = requestType

//    if selectedItem?.type == "serie" {
//      request = "SEASONS"
//    }
//    else if selectedItem?.type == "season" {
//      request = "EPISODES"
//    }
//    else if selectedItem?.type == "selection" {
//      request = "SELECTION"
//    }
//    else if selectedItem?.type == "soundtrack" {
//      request = "ALBUMS"
//    }
//    else if selectedItem?.type == "tracks" {
//      request = "TRACKS"
//
//      tracks = selectedItem!.tracks
//    }

    switch request {
      case "BOOKMARKS":
        bookmarks.load()
        result = ["movies": bookmarks.getBookmarks(pageSize: pageSize, page: currentPage)]

      case "HISTORY":
        history.load()
        result = ["movies": history.getHistoryItems(pageSize: pageSize, page: currentPage)]

      case "NewBooks":
        result = try service.getNewBooks(page: currentPage)

//      case "ALL_SERIES":
//        result = try service.getAllSeries(page: currentPage)
//
//      case "MOVIES":
//        let path = selectedItem!.id
//
//        result = try service.getMovies(path: path!, page: currentPage)

//      case "SERIES":
//        let path = selectedItem!.id
//
//        result = try service.getSeries(path: path!, page: currentPage)
//
//      case "POPULAR_MOVIES":
//        result = try service.getPopularMovies(page: currentPage)
//
//      case "POPULAR_SERIES":
//        result = try service.getPopularSeries(page: currentPage)

//      case "SEASONS":
//        result = service.getSeasons(identifier!, parentName: selectedItem!.name!)
//
//        let seasons = result["movies"] as! [Any]
//
//        if seasons.count == 1 {
//          let episodes = (seasons[0] as! [String: Any])["episodes"]
//
//          result = ["movies": episodes!]
//        }
//
//      case "EPISODES":
//        let seasonNumber = selectedItem?.seasonNumber ?? ""
//
//        let parentName = "\(selectedItem!.parentName!) (\(selectedItem!.name!))"
//
//        result = service.getEpisodes(identifier!, parentName: parentName, seasonNumber: seasonNumber, pageSize: pageSize, page: currentPage)
//
//      case "SELECTIONS":
//        result = try service.getSelections(page: currentPage)

//      case "SELECTION":
//        let selectionId = selectedItem!.id!
//
//        result = try service.getSelection(path: selectionId, page: currentPage)
//
////      case "SOUNDTRACKS":
////        result = try service.getSoundtracks(page: currentPage)
//
//      case "ALBUMS":
//        let soundtrackId = selectedItem!.id!
//
//        result = try service.getAlbums(soundtrackId)
//
//        let albums = result["movies"] as! [Any]
//
//        if albums.count == 1 {
//          let tracks = (albums[0] as! [String: Any])["tracks"]
//
//          result = ["movies": tracks!]
//        }
//
//      case "TRACKS":
//        result = ["movies": tracks]

//      case "MOVIES_FILTER":
//        let data = try service.getFilters(mode: "film")
//
//        result = ["movies": data]
//
//      case "MOVIES_SUB_FILTER":
//        result = ["movies": selectedItem!.items]
//
//      case "SERIES_FILTER":
//        let data = try service.getFilters(mode: "serial")
//
//        result = ["movies": data]
//
//      case "SERIES_SUB_FILTER":
//        result = ["movies": selectedItem!.items]
//
//      case "SOUNDTRACKS":
//        result = try service.getSoundtracks(page: currentPage)

      case "SEARCH":
        if !identifier!.isEmpty {
          result = try service.search(identifier!, page: currentPage)
        }

      default:
        result = ["movies": []]
    }

    var newItems = [MediaItem]()

    let result2 = result["movies"] as! [Any]

    for item in result2 {
      var jsonItem = item as? JSON

      if jsonItem == nil {
        jsonItem = JSON(item)
      }

      let movie = AudioKnigiMediaItem(data: jsonItem!)

      newItems += [movie]
    }

    return newItems
  }
}