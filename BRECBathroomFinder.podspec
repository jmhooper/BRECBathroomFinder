Pod::Spec.new do |s|
  s.name = "BRECBathroomFinder"
  s.version = "1.0.0"
  s.summary = "A pod that finds nearby BREC parks with restrooms"
  s.description = <<-DESC
                  This is a project built on top of Baton Rouge's Open Data API. It uses a query to find parks with bathrooms.

                  The results can be sorted according to how close the parks are to a given location or the user's location.
                  DESC
  s.homepage = "https://github.com/jmhooper/BRECBathroomFinder"
  s.author = { "Jonathan Hooper" => "jon9820@gmail.com"  }
  s.license = 'MIT'
  s.source = { git: "https://github.com/jmhooper/BRECBathroomFinder.git", tag: s.version.to_s }
  s.platform = :ios, '8.0'
  s.requires_arc = true
  s.source_files = "BRECBathroomFinder/**/*"
  s.dependency "AFNetworking", "~> 2.0"
  s.frameworks = "CoreLocation"
  s.prefix_header_contents = "#import <AFNetworking/AFNetworking.h>"
end
