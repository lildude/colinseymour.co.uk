#!/usr/bin/env ruby
# Quick hacky script to get all my instagram images and create posts from them.
require 'json'
require 'colorize'
require 'date'
require 'open-uri'
require 'erb'
source = JSON.parse(IO.read('/Users/lildude/tmp/insta.json'))

source.each do |entry|
  @entry = entry
  print "Downloading and creating post for" + " #{@entry['short_code']}".yellow + "... "

  begin
    # Download the image
    File.write("assets/#{@entry['short_code']}.jpg", open(@entry['media']).read, {mode: 'wb'})

    # Create the post
    @pub_date = DateTime.strptime(entry['time'].to_s, '%s')
    #pub_date.strftime("%F %T %z")
    if @entry['text']
      if @entry['text'].split.size > 8
        @title = "#{@entry['text'].split[0...8].join(' ')}…"
      else
        @title = @entry['text']
      end
    else
      @title = "Instagram - #{@entry['short_code']}"
    end
    content = ERB.new <<-EOF
---
layout: post
date: <%= @pub_date.strftime("%F %T %z") %>
title: '<%= @title.gsub(/"/, '') %>'
type: post
tags:
- instagram
instagram_url: <%= @entry['link'] %>
---

![Instagram - <%= @entry['short_code'] %>](/assets/<%= File.basename(@entry['short_code']) %>.jpg){:class="instagram"}

<%= @entry['text'] %>
EOF

    File.open("_posts/#{@pub_date.strftime("%F")}-#{@entry['short_code']}.md", 'w') {|f| f.write(content.result) }
    puts "DONE".green
  rescue Exception => e
    puts "FAILED".red
    puts e.message
    puts e.backtrace
  end
end
