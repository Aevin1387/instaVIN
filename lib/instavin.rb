require "instavin/version"
require "instavin/errors"
require "instavin/reports"
require "symboltable"

module InstaVIN
  extend self

  def configure
    yield config
  end

  def config
    @@config ||= SymbolTable.new
  end
end
