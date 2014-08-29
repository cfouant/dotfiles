# -*- coding: utf-8 -*-
#
# ~/.pryrc
# vim:ft=ruby

Pry.config.editor = "#{ENV['EDITOR']}"

begin
  print 'awesome_print'
  require 'awesome_print'
  AwesomePrint.pry!
  puts ' loaded'
rescue LoadError
  puts ' not found'
end

begin
  print 'hirb'
  require 'hirb'
  Hirb.enable
  puts ' loaded'
rescue LoadError
  puts ' not found'
end

%w(pry-debugger pry-stack_explorer pry-rescue).each do |lib|
  begin
    print lib
    require lib
    puts ' loaded'
  rescue LoadError
    puts ' not found'
  end
end

if defined?(PryDebugger)
  Pry.commands.alias_command('c', 'continue')
  Pry.commands.alias_command('f', 'finish')
  Pry.commands.alias_command('s', 'step')
  Pry.commands.alias_command('n', 'next')
  Pry.commands.alias_command('l', 'whereami')
end
