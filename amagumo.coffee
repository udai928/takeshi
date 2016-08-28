# Description:
#   A hubot script return Yahoo Rain-cloud(Amagumo) Radar infomation.
#
# Commands:
#   hubot 雨雲どう？@<area> - Returns a Yahoo Rain-Cloud(Amagumo) Rader map view of <area>
#   hubot 雨雲どう？ zoom@<area> - Returns a zoom Rader map view of <area>
#   hubot amagumo japan - Returns a Rader map view of the whole japan area
#
# Author:
#   asmz

module.exports = (robot) ->

  HUBOT_YAHOO_AMAGUMO_APP_ID = ""
  width = "500"
  height = "500"

  robot.respond /amagumo japan/i, (msg) ->
    msg.send getAmagumoRaderUrl "37.9072841", "137.1255805", "6", "500", "500", HUBOT_YAHOO_AMAGUMO_APP_ID

  robot.respond /雨雲レーダー( zoom)?@(.+)/i, (msg) ->
    zoom = if msg.match[1] then "14" else "12"
    area = msg.match[2]

    msg.http('http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder')
      .query({
        appid: HUBOT_YAHOO_AMAGUMO_APP_ID
        query: area
        results: 1
        output: 'json'
      })  
      .get() (err, res, body) ->
        geoinfo = JSON.parse(body)
        unless geoinfo.Feature?
          msg.send "Not match \"#{area}\""
          return

        coordinates = (geoinfo.Feature[0].Geometry.Coordinates).split(",")
        lon = coordinates[0]
        lat = coordinates[1]

        msg.send getAmagumoRaderUrl lat, lon, zoom, width, height, HUBOT_YAHOO_AMAGUMO_APP_ID

getAmagumoRaderUrl = (lat, lon, zoom, width, height, key) ->
  url = "http://map.olp.yahooapis.jp/OpenLocalPlatform/V1/static?appid=" +
         key +
        "&lat=" + lat +
        "&lon=" + lon +
        "&z=" + zoom +
        "&width=" + width +
        "&height=" + height +
        "&overlay=" + "type:rainfall"
