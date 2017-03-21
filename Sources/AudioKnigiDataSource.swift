import SwiftyJSON
import WebAPI
import TVSetKit

class AudioKnigiDataSource: DataSource {
  let service = AudioKnigiService.shared

  func load(_ requestType: String, params: RequestParams, pageSize: Int, currentPage: Int) throws -> [MediaItem] {
    var result: [Any] = []

    let identifier = params.identifier
    let bookmarks = params.bookmarks!
    let history = params.history!
    let selectedItem = params.selectedItem

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
        result = bookmarks.getBookmarks(pageSize: pageSize, page: currentPage)

      case "HISTORY":
        history.load()
        result = history.getHistoryItems(pageSize: pageSize, page: currentPage)

      case "New Books":
        result = try service.getNewBooks(page: currentPage)["movies"] as! [Any]

      case "Best Books":
        var period = "all"

        if selectedItem!.name == "By Month" {
          period = "30"
        }
        else if selectedItem!.name == "By Week" {
          period = "7"
        }

        result = try service.getBestBooks(period: period)["movies"] as! [Any]

      case "Authors Letters":
        var letters = [Any]()

        let response = try service.getAuthorsLetters()

        for item in response {
          let name = item as! String

//        if !["Ё", "Й", "Щ", "Ъ", "Ы", "Ь"].contains(letter) {
//          items.append(MediaItem(name: letter))
//        }

          letters.append(["name": name])
        }

        result = letters

      case "Authors Letters Group":
        let letter = identifier

        if letter == "Все" {
          result = try service.getAuthors(page: currentPage)["movies"] as! [Any]
        }
        else {
          var letterGroups = [Any]()

          for (groupName, group) in AudioKnigiService.Authors {
            if groupName[groupName.startIndex] == letter![groupName.startIndex] {
              //letterGroups.append([(key: groupName, value: group)])
              letterGroups.append(["name": groupName, "items": group])
            }
          }

          result = letterGroups
        }

      case "Books":
        let path = selectedItem!.name

        result = try service.getBooks(path: path!, page: currentPage)["movies"] as! [Any]

      case "SEARCH":
        if !identifier!.isEmpty {
          result = try service.search(identifier!, page: currentPage)["movies"] as! [Any]
        }

      default:
        result = []
    }

    return convertToMediaItems(result)
  }

  func convertToMediaItems(_ items: [Any]) -> [MediaItem] {
    var newItems = [MediaItem]()

    for item in items {
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