# -*- encoding : utf-8 -*-

require 'bundler'
Bundler.require

require './app'

set :environment, ENV['RACK_ENV'].to_sym
set :base_url, ENV['BASE_URL']
disable :run, :reload

run Sinatra::Application
