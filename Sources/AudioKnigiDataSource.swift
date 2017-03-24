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

      case "Authors In Range":
        let audioItem = selectedItem as! AudioKnigiMediaItem

        result = audioItem.items

      case "Author":
        let path = selectedItem!.id

        let books = try service.getBooks(path: path!, page: currentPage)["movies"] as! [Any]

//        var newBooks: [Any] = []
//
//        for book in books {
//          newBooks.append(["name": (book as! [String: String])["name"], "id": (book as! [String: String])["id"], "type": "book"])
//        }
//
//        result = newBooks

        print(books)

        result = books

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
//          letters.append(["name": name])
//        }

          letters.append(["name": name])
        }

        result = letters

      case "All Authors Letters Group":
        result = try service.getAuthors(page: currentPage)["movies"] as! [Any]
        print(result)

      case "Authors Letters Group":
        let letter = identifier

        var letterGroups = [Any]()

        for (groupName, group) in AudioKnigiService.Authors {
          if groupName[groupName.startIndex] == letter![groupName.startIndex] {
            letterGroups.append(["name": groupName, "items": group])
          }
        }

        result = letterGroups

      case "Performers Letters":
        var letters = [Any]()

        let response = try service.getPerformersLetters()

        for item in response {
          let name = item as! String

  //        if !["Ё", "Й", "Щ", "Ъ", "Ы", "Ь"].contains(letter) {
  //          letters.append(["name": name])
  //        }

          letters.append(["name": name])
        }

        result = letters

      case "All Performers Letters Group":
        result = try service.getPerformers(page: currentPage)["movies"] as! [Any]
        print(result)

      case "Performers Letters Group":
        let letter = identifier

        var letterGroups = [Any]()

        for (groupName, group) in AudioKnigiService.Performers {
          if groupName[groupName.startIndex] == letter![groupName.startIndex] {
            letterGroups.append(["name": groupName, "items": group])
          }
        }

        result = letterGroups

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