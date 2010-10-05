$:.unshift File.dirname(__FILE__)

require 'rubygems'
gem 'activesupport'
require 'active_support'
require 'active_support/core_ext/hash/reverse_merge' # @todo: 1.9 requires this to be explicitly included - why?
require 'net/https'

require 'fusebox/version'
require 'fusebox/request'
require 'fusebox/response'
require 'fusebox/core_ext/net_http'