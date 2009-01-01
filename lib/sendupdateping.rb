$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'xmlrpc/client'
require 'pp'

# =sendupdateping.rb
# sendupdateping is a ruby library to send updateping.
# see also
# - http://weblogs.com/api.html
# - http://isnot.jp/?p=XML-RPC%A1%F8%B9%B9%BF%B7Ping%A4%CE%C1%F7%BF%AE
module Sendupdateping
  VERSION = '0.0.1'
  class Sendupdateping
    # opts(Hash) contains
    # - :pingservers Array of pingservers list
    # - :weblogname  your blog name
    # - :weblogurl   your blog url
    # - :extendedping(optional) use weblogUpdates.extendedPing instead of weblogUpdates.ping
    # - :changesurl  (optional) your blog's top page used when weblogUpdates.extendedPing
    # - :rssurl      (optional) your blog's rss feed url used when weblogUpdates.extendedPing
    # - :categoryname(optional) the category in which is your blog used when weblogUpdates.extendedPing
    def initialize(opts)
      pp opts
      @pingservers= Array.new( opts[:pingservers] )
      @weblogname = opts[:weblogname]
      @weblogurl  = opts[:weblogurl]
      @changesurl = opts[:changesurl]|| opts[:weblogurl]
      @rssurl     = opts[:rssurl]
      @categoryname=opts[:categoryname]
      @extendedPing=opts[:extendedping]
    end

    # send ping
    def ping
      @pingservers.each do |pingserver|
        print pingserver , " : "
        client = XMLRPC::Client.new2(pingserver)
        begin
          if @extendedPing and @changesurl and @rssurl and @categoryname
            result = client.call( 'weblogUpdates.extendedPing', @weblogname, @weblogurl, @changesurl, @rssurl, @categoryname)
          else
            result = client.call('weblogUpdates.ping', @weblogname, @weblogurl)
          end
          print 'Error : ' if result["ferror"]
          print result["message"]
          print '  ', result["legal"] if result["legal"]
          print "\n"
        rescue
          print "There is an error : ", $!, "\n"
        end
      end
    end
  end
end
