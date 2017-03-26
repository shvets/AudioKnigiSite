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

    if selectedItem?.type == "book" {
      request = "Tracks"
    }

    switch request {
      case "Bookmarks":
        bookmarks.load()
        result = bookmarks.getBookmarks(pageSize: pageSize, page: currentPage)

      case "History":
        history.load()
        result = history.getHistoryItems(pageSize: pageSize, page: currentPage)

      case "Author":
        let path = selectedItem!.id

        result = try service.getBooks(path: path!, page: currentPage)["movies"] as! [Any]

      case "Performer":
        let path = selectedItem!.id

        result = try service.getBooks(path: path!, page: currentPage)["movies"] as! [Any]

      case "Genre Books":
        let path = selectedItem!.id

        result = try service.getBooks(path: path!, page: currentPage)["movies"] as! [Any]

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

        result = try service.getBestBooks(period: period, page: currentPage)["movies"] as! [Any]

      case "All Authors":
        result = try service.getAuthors(page: currentPage)["movies"] as! [Any]

      case "Authors Letters":
        let letters = try service.getAuthorsLetters()

        var list = [Any]()

        for letter in letters {
          list.append(["name": letter])
        }

        result = list

      case "Authors Letter Groups":
        let letter = identifier!

        var letterGroups = [Any]()

        for (groupName, group) in AudioKnigiService.Authors {
          if groupName[groupName.startIndex] == letter[groupName.startIndex] {
            letterGroups.append(["name": groupName, "items": group])
          }
        }

        result = letterGroups

      case "Performers Letters":
        let letters = try service.getPerformersLetters()

        var list = [Any]()

        for letter in letters {
          list.append(["name": letter])
        }

        result = list

      case "Performers Letter Groups":
        let letter = identifier!

        var letterGroups = [Any]()

        for (groupName, group) in AudioKnigiService.Performers {
          if groupName[groupName.startIndex] == letter[groupName.startIndex] {
            letterGroups.append(["name": groupName, "items": group])
          }
        }

        result = letterGroups

      case "Group Authors":
        result = (selectedItem as! AudioKnigiMediaItem).items

      case "All Performers":
        result = try service.getPerformers(page: currentPage)["movies"] as! [Any]

      case "Group Performers":
        result = (selectedItem as! AudioKnigiMediaItem).items

      case "Genres":
        result = try service.getGenres(page: currentPage)["movies"] as! [Any]

      case "Tracks":
        let url = selectedItem!.id!

        result = try service.getAudioTracks(url)

      case "Search":
        if !identifier!.isEmpty {
          result = try service.search(identifier!, page: currentPage)["movies"] as! [Any]
        }
        else {
          result = []
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
