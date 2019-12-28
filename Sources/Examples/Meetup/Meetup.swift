// Copyright 2019 Google LLC. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import Dispatch
import OAuth2

class MeetupSession {
  
  var connection : Connection
  
  init(tokenProvider: TokenProvider) throws{
    connection = try Connection(provider:tokenProvider)
  }
  
  func getMe() throws {
    let sem = DispatchSemaphore(value: 0)
    var responseData : Data?
    try connection.performRequest(
      method:"GET",
      urlString:"https://api.meetup.com/dashboard") {(data, response, error) in
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let data = responseData {
      let response = String(data: data, encoding: .utf8)!
      print(response)
    }
  }
  
  func getRSVPs(eventid : String) throws {
    let sem = DispatchSemaphore(value: 0)
    var responseData : Data?
    try connection.performRequest(
      method:"GET",
      urlString:"https://api.meetup.com/sviphone/events/\(eventid)/rsvps") {(data, response, error) in
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let data = responseData {
      let response = String(data: data, encoding: .utf8)!
      print(response)
    }
  }
  
  func getEvents() throws {
    let sem = DispatchSemaphore(value: 0)
    let parameters : [String:String] = ["status":"past"]
    var responseData : Data?
    try connection.performRequest(
      method:"GET",
      urlString:"https://api.meetup.com/sviphone/events",
      parameters: parameters,
      body: nil) {(data, response, error) in
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let data = responseData {
      let response = String(data: data, encoding: .utf8)!
      print(response)
    }
  }
}
