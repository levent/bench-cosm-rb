require "rubygems"
require "bundler/setup"

require 'cosm-rb'
require 'benchmark'
include Benchmark

RUNS = 10000
ds = []
10.times {ds << Cosm::Datastream.new({:id => "ds#{rand(1000)}", :current_value => rand(1024), :updated => Time.now})}
feed = Cosm::Feed.new(:title => "Profile feed", :datastreams => ds, :tags => ["a", "b", "c"])
json = feed.to_json
xml = feed.to_xml
csv = feed.to_csv

Benchmark.benchmark(" "*10 + CAPTION, 10, FMTSTR) do |x|
  x.report("feed#to_json") do
    RUNS.times do
      feed.to_json
    end
  end

  x.report("feed#to_xml") do
    RUNS.times do
      feed.to_xml
    end
  end

  x.report("feed#to_csv") do
    RUNS.times do
      feed.to_csv
    end
  end

  x.report("feed#from_json") do
    RUNS.times do
      Cosm::Feed.new(json)
    end
  end

  x.report("feed#from_xml") do
    RUNS.times do
      Cosm::Feed.new(xml)
    end
  end

  x.report("feed#from_csv") do
    RUNS.times do
      Cosm::Feed.new(csv, :v2)
    end
  end
end
