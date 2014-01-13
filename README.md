# fusebox

## Description

[FuseMail](http://fusemail.com) is a business email hosting provider offering outsourced email hosting to businesses and resellers.

**fusebox** is a ruby gem that provides a 1:1 native ruby interface for every command of [FuseMail Platform Programming Interface v2.6](https://www.fusemail.com/support/api-documentation/), which allows you to manage your accounts, domains, forwards, and aliases via an underlying HTTP interface.

## Installation
    $ gem install fusebox

## Configuration
Although the library supports passing a username and password to {Fusebox::Request#initialize}, we recommend storing authentication information in a YAML file within {Fusebox::Request.auth_yaml_paths} as:

    $ cat ~/.fusemail.yaml
    username: my_username
    password: my_password

## Command Line Interface (CLI)
fusebox comes with a command line interface (written on the amazing [thor](http://github.com/wycats/thor/)).  CLI usage requires the setup of a ~/.fusemail.yaml authentication file. For a command list type:
    $ fusebox help
or for command specific flags, e.g. "rm"
    $ fusebox help rm

Note: The CLI interface *currently* assumes all group accounts are named postmaster@example.com, and that the username for all accounts is a full email address.

## Library Examples
### Fetch a list of users
    response = Fusebox::Request.new.report
    if response.success?
       response.records.each { |user| puts user.inspect }
    end

### Create a new account
    response = Fusebox::Request.new.order(:account_type => 'group_subaccount', :group_parent => "postmaster@example.com", :user => "user@example.com", :password => 'WooEmail!', :first_name => 'Test', :last_name => 'User')
    if response.success?
      puts "Success!"
    else
      puts "Failure: " + response.detail
    end

See the [Fusebox::Request](http://rubydoc.info/github/mudbugmedia/fusebox/master/Fusebox/Request) documentation for more commands.

## Documentation
* [Project Documentation](http://rubydoc.info/github/mudbugmedia/fusebox/master/frames)
* [Command Documentation](http://rubydoc.info/github/mudbugmedia/fusebox/master/Fusebox/Request)

## TODO
* Logging hook
* Leverage ActiveModel to create Account, Domain, Alias, etc, classes.

## Authors
The fusebox gem is independently developed and maintained by [Mudbug Media](http://mudbugmedia.com/) and [Gabe Martin-Dempesy](http://mudbugmedia.com/team/gabe).

FuseMail LLC, and its parent company j2 Global Communications, do not provide support or maintenance for this software.

Copyright &copy; 2010 - 2014
