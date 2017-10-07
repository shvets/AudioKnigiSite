import SwiftyJSON
import WebAPI
import TVSetKit
import AudioPlayer

class AudioKnigiDataSource: DataSource {
  let service = AudioKnigiService.shared

  override open func load(params: Parameters) throws -> [Any] {
    var result: Any?
    var tracks = false

    let selectedItem = params["selectedItem"] as? MediaItem

    var request = params["requestType"] as! String
    //var pageSize = params["pageSize"] as? Int
    let currentPage = params["currentPage"] as! Int

    if selectedItem?.type == "book" {
      request = "Tracks"
    }

    switch request {
    case "Bookmarks":
      if let bookmarks = params["bookmarks"]  as? Bookmarks {
        bookmarks.load()
        result = bookmarks.getBookmarks(pageSize: 60, page: currentPage)
      }

    case "History":
      if let history = params["history"] as? History {
        history.load()
        result = history.getHistoryItems(pageSize: 60, page: currentPage)
      }

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
      let letters = getLetters(AudioKnigiService.Authors)

      var list = [Any]()

      list.append(["name": "Все"])

      for letter in letters {
        list.append(["name": letter])
      }

      result = list

    case "Authors Letter Groups":
      if let letter = params["parentId"] as? String {
        var letterGroups = [Any]()

        for author in AudioKnigiService.Authors {
          let groupName = author.key
          let group = author.value

          if groupName[groupName.startIndex] == letter[groupName.startIndex] {
            var newGroup: [Any] = []

            for el in group {
              newGroup.append(["id": el.id, "name": el.name])
            }

            letterGroups.append(["name": groupName, "items": newGroup])
          }
        }

        result = letterGroups
      }

    case "Authors":
      result = (selectedItem as! AudioKnigiMediaItem).items

    case "Author":
      let path = selectedItem!.id

      result = try service.getBooks(path: path!, page: currentPage)["movies"] as! [Any]

    case "Performers Letters":
      let letters = getLetters(AudioKnigiService.Performers)

      var list = [Any]()

      list.append(["name": "Все"])

      for letter in letters {
        list.append(["name": letter])
      }

      result = list

    case "Performers Letter Groups":
      if let letter = params["parentId"] as? String {
        var letterGroups = [Any]()

        for performer in AudioKnigiService.Performers {
          let groupName = performer.key
          let group = performer.value

          if groupName[groupName.startIndex] == letter[groupName.startIndex] {
            var newGroup: [Any] = []

            for el in group {
              newGroup.append(["id": el.id, "name": el.name])
            }

            letterGroups.append(["name": groupName, "items": newGroup])
          }
        }

        result = letterGroups
      }

    case "Performers":
      result = (selectedItem as! AudioKnigiMediaItem).items

    case "Performer":
      let path = selectedItem!.id

      result = try service.getBooks(path: path!, page: currentPage)["movies"] as! [Any]

    case "All Performers":
      result = try service.getPerformers(page: currentPage)["movies"] as! [Any]

    case "Genres":
      result = try service.getGenres(page: currentPage)["movies"] as! [Any]

    case "Tracks":
      let url = selectedItem!.id!

      tracks = true
      result = try service.getAudioTracks(url)

    case "Search":
      if let query = params["query"] as? String {
        if !query.isEmpty {
          result = try service.search(query, page: currentPage)["movies"] as! [Any]
        }
        else {
          result = []
        }
      }

    default:
      result = []
    }

    let convert = params["convert"] as? Bool ?? true

    if convert || tracks {
      return convertToMediaItems(result as Any)
    }
    else {
      return result as! [Any]
    }
  }

  func convertToMediaItems(_ items: Any) -> [Any] {
    var newItems = [Any]()

    if let tracks = items as? [AudioKnigiAPI.Track] {
      for track in tracks {
        let item = AudioItem(name: track.title + ".mp3", id: track.url)

        newItems += [item]
      }
    }
    else if let items = items as? [Any] {
      for item in items {
        var jsonItem = item as? JSON

        if jsonItem == nil {
          jsonItem = JSON(item)
        }

        let movie = AudioKnigiMediaItem(data: jsonItem!)

        newItems += [movie]
      }
    }

    return newItems
  }

  func getLetters(_ items: [NameClassifier.ItemsGroup]) -> [String] {
    var rletters = [String]()
    var eletters = [String]()

    for item in items {
      let groupName = item.key

      let index = groupName.index(groupName.startIndex, offsetBy: 0)

      let letter = String(groupName[index])

      if (letter >= "a" && letter <= "z") || (letter >= "A" && letter <= "Z") {
        if !eletters.contains(letter) {
          eletters.append(letter)
        }
      }
      else if (letter >= "а" && letter <= "я") || (letter >= "А" && letter <= "Я") {
        if !rletters.contains(letter) {
          rletters.append(letter)
        }
      }
    }

    return rletters + eletters
  }

}
