require "rubygems"
require "bundler/setup"

require 'cosm-rb'
require 'ruby-prof'

ds = []
10.times {ds << Cosm::Datastream.new({:id => "ds#{rand(1000)}", :current_value => rand(1024)})}
feed = Cosm::Feed.new(:title => "Profile feed", :datastreams => ds)

RubyProf.start

1000.times {feed.to_json}

result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
