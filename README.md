# BREC Bathroom Finder

This is a project built on top of Baton Rouge's Open Data API.
It uses a query to find parks with bathrooms.

The results can be sorted according to how close the parks are to a given location or the user's location.

## Dependencies

This project has 2 dependencies that are not included:

- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- [Core Location Framework](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CoreLocation_Framework/)

## Use

1. Install the [AFNetworking](https://github.com/AFNetworking/AFNetworking) dependency
2. Add the [Core Location](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CoreLocation_Framework/) framework to your project
3. Clone the BREC Bathroom Finder project and add the files from the `BRECBathroomFinder` directory to your project.

## Examples

Finding park restrooms:
```swift
BBFBathroomLocator.sharedLocator().findBathrooms(success: { (bathrooms: Array<BBFBathroom>) -> Void in
  self.bathrooms = bathrooms
  self.tableView.reloadData()
}, failure: { (error: NSError) -> Void in
  // Handle the error
})
```

Finding park restrooms near a location

```swift
BBFBathroomLocator.sharedLocator().findBathroomNearLocation(location, success: { (bathrooms: Array<BBFBathroom>) -> Void in
  self.bathrooms = bathrooms
  self.tableView.reloadData()
}, failure: { (error: NSError) -> Void in
  // Handle the error
})
```

Finding park restrooms near the current user

```swift
BBFBathroomLocator.sharedLocator().findBathroomsNearby(success: { (bathrooms: Array<BBFBathroom>) -> Void in
  self.bathrooms = bathrooms
  self.tableView.reloadData()
}, failure: { (error: NSError) -> Void in
  // Handle the error
})
```

## TODO

- [ ] Add a demo project
- [ ] Setup a podspec
- [ ] Cache bathrooms since that data doesn't change regularly
