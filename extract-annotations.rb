#!/usr/bin/env ruby

require 'sqlite3'
require 'json'
require 'securerandom'
require 'tmpdir'

DBFILENAME = 'webappsstore.sqlite'.freeze

canvasPrefix = ARGV[0] # as much of the canvas uri pattern as you need to select your annotations
scope = (ARGV[1] || 'projectmirador.org').reverse

firefox = ENV['FIREFOX_PROFILE'] # full path, like '/home/pbinkley/.mozilla/firefox/kkfnzolx.default'

# copy live db to working location, to unlock it
# note: mine is 148mb

tempDB = "#{Dir.tmpdir()}/#{DBFILENAME}"

FileUtils.cp("#{firefox}/#{DBFILENAME}", tempDB)

db = SQLite3::Database.new(tempDB)
query = "SELECT value FROM webappsstore2 where scope like \"#{scope}%\" and key like \"#{canvasPrefix}%\";"
annotations = []

db.execute( query ) do |row|
  row.each do |val|
    JSON.parse(val).each do |item|
      # add region fragment to end of canvas URI to create annotation URI
      oldOn = item['on'].first
      newOn = "#{ oldOn['full'] }##{ oldOn['selector']['default']['value'] }"
      item['on'] = newOn
      item['motivation'] = 'oa:painting'
      annotations << item
    end
  end
end

db.close

# convert into simple list, modelled on https://github.com/glenrobson/SimpleAnnotationServer/blob/master/src/main/webapp/examples/anno_list.json

list = {
    "@context": "http://iiif.io/api/presentation/2/context.json",
    "@id": SecureRandom.uuid,
    "@type": "sc:AnnotationList",
    "resources": annotations
  }

puts JSON.pretty_generate(list)

# don't leave the temp copy lying around
FileUtils.rm(tempDB)
