require "rubygems"
require "bundler/setup"

require 'cosm-rb'
require 'ruby-prof'

ds = []
10.times {ds << Cosm::Datastream.new({:id => "ds#{rand(1000)}", :current_value => rand(1024), :updated => Time.now})}
feed = Cosm::Feed.new(:title => "Profile feed", :datastreams => ds)
json = feed.to_json
xml = feed.to_xml

RubyProf.start

1000.times {Cosm::Feed.new(xml)}

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
