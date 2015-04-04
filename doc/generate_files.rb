#!/usr/bin/env ruby -wKU

require 'yaml'
require 'date'

class Generator
  def run
    10.times do |i|
      File.open(name(i), 'w') do |f|
        f.puts Article.new.content
      end
    end
  end

  def name(i)
    filename = 'temp' + "#{(i+1).to_s.rjust(4, '0')}" + '.md'
    "content/post/#{filename}"
  end
end


class Article
  require 'securerandom'
  def content
    [metadata, body].join("\n")
  end

  def metadata
    date = Date.new( rand(4) + 2012, rand(12)+1, rand(25)+1).to_s
    {
      'title'     => random_string,
      'date'      => date,
      'published' => true,
      'tags'      => ['Example', 'Markdown'],
    }.to_yaml + "\n---"
  end


  def body
    (rand(15) + 4).times.map do |i|
      sentence
    end.join("\n")
  end

  def random_string
    SecureRandom.hex.tap do |s|
      s.gsub!(/\d/, '')
    end
  end

  def sentence
    [].tap do |a|
      rand(13).times do
        a.push random_string
      end
    end.join(" ") + "."
  end
end


#puts Article.new.content
Generator.new.run
