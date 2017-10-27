import WebAPI
import TVSetKit
import AudioPlayer

class AudioKnigiDataSource: DataSource {
  let service = AudioKnigiService.shared

  override open func load(params: Parameters) throws -> [Any] {
    var items = [Item]()

    let selectedItem = params["selectedItem"] as? Item
    let request = params["requestType"] as! String
    let currentPage = params["currentPage"] as? Int ?? 1

    switch request {
    case "Bookmarks":
      if let bookmarksManager = params["bookmarksManager"] as? BookmarksManager,
         let bookmarks = bookmarksManager.bookmarks {
        let data = bookmarks.getBookmarks(pageSize: 60, page: currentPage)

        items = adjustItems(data)
      }

    case "History":
      if let historyManager = params["historyManager"] as? HistoryManager,
         let history = historyManager.history {
        let data = history.getHistoryItems(pageSize: 60, page: currentPage)

        items = adjustItems(data)
      }

    case "Genre Books":
      if let selectedItem = selectedItem,
         let path = selectedItem.id,
         let data = try service.getBooks(path: path, page: currentPage)["movies"] as? [Any] {
        items = adjustItems(data)
      }

    case "New Books":
      if let data = try service.getNewBooks(page: currentPage)["movies"] as? [Any] {
        items = adjustItems(data)
      }

    case "Best Books":
      var period = "all"

      if let selectedItem = selectedItem {
        if selectedItem.name == "By Month" {
          period = "30"
        }
        else if selectedItem.name == "By Week" {
          period = "7"
        }

        if let data = try service.getBestBooks(period: period, page: currentPage)["movies"] as? [Any] {
          items = adjustItems(data)
        }
      }

    case "All Authors":
      if let data = try service.getAuthors(page: currentPage)["movies"] as? [Any] {
        items = adjustItems(data)
      }

    case "Authors Letters":
      items = adjustItems(getLettersItems(AudioKnigiService.Authors))

    case "Authors Letter Groups":
      if let letter = params["parentId"] as? String {
        items = adjustItems(getLetterGroups(AudioKnigiService.Authors, letter: letter))
      }

    case "Authors":
      if let selectedItem = selectedItem as? AudioKnigiMediaItem {
        items = adjustItems(selectedItem.items)
      }

    case "Author":
      if let selectedItem = selectedItem,
         let path = selectedItem.id,
         let data = try service.getBooks(path: path, page: currentPage)["movies"] as? [Any] {
        items = adjustItems(data)
      }

    case "Performers Letters":
      items = adjustItems(getLettersItems(AudioKnigiService.Performers))

    case "Performers Letter Groups":
      if let letter = params["parentId"] as? String {
        items = adjustItems(getLetterGroups(AudioKnigiService.Performers, letter: letter))
      }

    case "Performers":
      if let selectedItem = selectedItem as? AudioKnigiMediaItem {
        items = adjustItems(selectedItem.items)
      }

    case "Performer":
      if let selectedItem = selectedItem,
         let path = selectedItem.id,
         let data = try service.getBooks(path: path, page: currentPage)["movies"] as? [Any] {

        items = adjustItems(data)
      }

    case "All Performers":
      if let data = try service.getPerformers(page: currentPage)["movies"] as? [Any] {
        items = adjustItems(data)
      }

    case "Genres":
      if let data = try service.getGenres(page: currentPage)["movies"] as? [Any] {
        items = adjustItems(data)
      }

    case "Tracks":
      if let selectedItem = selectedItem,
         let url = selectedItem.id {
         let tracks = try service.getAudioTracks(url)
        items = adjustItems(tracks)
      }

    case "Search":
      if let query = params["query"] as? String {
        if !query.isEmpty,
           let data = try service.search(query, page: currentPage)["movies"] as? [Any] {
          items = adjustItems(data)
        }
      }

    default:
      items = []
    }

    return items
  }

  func adjustItems(_ items: [Any]) -> [Item] {
    var newItems = [Item]()

    if let items = items as? [HistoryItem] {
      newItems = transform(items) { item in
        createHistoryItem(item as! HistoryItem)
      }
    }
    else if let items = items as? [BookmarkItem] {
      newItems = transform(items) { item in
        createBookmarkItem(item as! BookmarkItem)
      }
    }
    else if let items = items as? [AudioKnigiAPI.PersonName] {
      newItems = transform(items) { item in
        let item = item as! AudioKnigiAPI.PersonName

        return MediaItem(name: item.name, id: String(describing: item.id))
      }
    }
    else if let items = items as? [AudioKnigiAPI.Track] {
      newItems = transform(items) { item in
        let track = item as! AudioKnigiAPI.Track

        return MediaItem(name: track.title + ".mp3", id: String(describing: track.url))
      }
    }

    else if let items = items as? [[String: Any]] {
      newItems = transform(items) { item in
        createMediaItem(item as! [String: Any])
      }
    } else if let items = items as? [Item] {
      newItems = items
    }

    return newItems
  }

  func createHistoryItem(_ item: HistoryItem) -> Item {
    let newItem = AudioKnigiMediaItem(data: ["name": ""])

    newItem.name = item.item.name
    newItem.id = item.item.id
    newItem.description = item.item.description
    newItem.thumb = item.item.thumb
    newItem.type = item.item.type

    return newItem
  }

  func createBookmarkItem(_ item: BookmarkItem) -> Item {
    let newItem = AudioKnigiMediaItem(data: ["name": ""])

    newItem.name = item.item.name
    newItem.id = item.item.id
    newItem.description = item.item.description
    newItem.thumb = item.item.thumb
    newItem.type = item.item.type

    return newItem
  }

  func createMediaItem(_ item: [String: Any]) -> Item {
    let newItem = AudioKnigiMediaItem(data: ["name": ""])

    if let dict = item as? [String: String] {
      newItem.name = dict["name"]
      newItem.id = dict["id"]
      newItem.description = dict["description"]
      newItem.thumb = dict["thumb"]
      newItem.type = dict["type"]
    } else {
      newItem.name = item["name"] as? String

      if let array = item["items"] as? [[String: String]] {
        var newArray = [AudioKnigiAPI.PersonName]()

        for elem in array {
          let newElem = AudioKnigiAPI.PersonName(name: elem["name"]!, id: elem["id"]!)

          newArray.append(newElem)
        }

        newItem.items = newArray
      }
    }

    return newItem
  }

  func getLetterGroups(_ list: [NameClassifier.ItemsGroup], letter: String) -> [[String: Any]] {
    var letterGroups = [[String: Any]]()

    for element in list {
      let groupName = element.key
      let group = element.value

      if groupName[groupName.startIndex] == letter[groupName.startIndex] {
        var newGroup: [Any] = []

        for el in group {
          newGroup.append(["id": el.id, "name": el.name])
        }

        letterGroups.append(["name": groupName, "items": newGroup])
      }
    }
    
    return letterGroups
  }

  func getLettersItems(_ list: [NameClassifier.ItemsGroup]) -> [[String: Any]] {
    let letters = getLetters(list)

    var items = [[String: Any]]()

    items.append(["name": "Все"])

    for letter in letters {
      items.append(["name": letter])
    }

    return items
  }

  func getLetters(_ items: [NameClassifier.ItemsGroup]) -> [String] {
    var ruLetters = [String]()
    var enLetters = [String]()

    for item in items {
      let groupName = item.key

      let index = groupName.index(groupName.startIndex, offsetBy: 0)

      let letter = String(groupName[index])

      if (letter >= "a" && letter <= "z") || (letter >= "A" && letter <= "Z") {
        if !enLetters.contains(letter) {
          enLetters.append(letter)
        }
      }
      else if (letter >= "а" && letter <= "я") || (letter >= "А" && letter <= "Я") {
        if !ruLetters.contains(letter) {
          ruLetters.append(letter)
        }
      }
    }

    return ruLetters + enLetters
  }

}
