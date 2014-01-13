require 'thor'
require 'fusebox/core_ext/array'

module Fusebox

  # These methods are executed via the `bin/fusebox` executable
  # @todo
  #   * Allow specification of group admin username-part instead of 'postmaster' (via yaml? fuseboxrc?)
  #   * Exit codes
  #   * Flags for simple, non-table output for report methods (to allow piping)
  class Cli < Thor
    include Thor::Actions

    desc "add user@example.com password first_name last_name", "Create user account under a group"
    def add (username, password, first_name, last_name)
      group_parent = username.gsub /.*(@.*)/, 'postmaster\1'
      response = Fusebox::Request.new.order(:account_type => 'group_subaccount', :group_parent => group_parent, :user => username, :password => password, :first_name => first_name, :last_name => last_name)
      say response.detail
    end

    desc "alias-add user@example.com alias1@example.com [alias2@example.com [...]]", "Add an alias to an account"
    def alias_add(username, *aliases)
      response = Fusebox::Request.new.modify(:user => username, :alias => aliases)
      say response.detail
    end

    desc "alias-ls user@example.com", "List aliases for a user"
    def alias_ls (username)
      response = Fusebox::Request.new.reportmail(:user => username, :report_type => 'alias')
      if response.success?
        response.records.sort { |x,y| x[:email_name] <=> y[:email_name]}.each { |a| say a[:email_name] }
      else
        warn response.detail
      end
    end

    desc "alias-rm user@example.com alias1@example.com", "Remove an alias from a maccount"
    def alias_rm (username, alias_address)
      response = Fusebox::Request.new.removealias(:user => username, :alias => alias_address)
      say response.detail
    end

    desc "domain-add [postmaster@]example.com new.example.com", "Add a domain a group account"
    def domain_add (username, domain)
      username = "postmaster@#{username}" unless username =~ /@/
      response = Fusebox::Request.new.adddomain(:user => username, :domain => domain)
      say response.detail
    end

    desc "domain-rm secondary.example.com", "Remove a domain"
    method_options [:force, '-f'] => false
    def domain_rm (domain)
      if options[:force] || yes?("Are you sure you want to remove domain: #{domain}? [y/N]")
        response = Fusebox::Request.new.removedomain(:domain => domain, :confirm => true)
        say response.detail
      end
    end

    desc "enable user@example.com", "Enable a suspended user account"
    def enable (username)
      response = Fusebox::Request.new.enable(:user => username)
      say response.detail
    end

    desc "get [user@]example.com", "Get aliases, forwarders, and mailing lists for an account"
    # @todo Display account metadata from `report`
    def get (username)
      username = "postmaster@#{username}" unless username =~ /@/
      response = Fusebox::Request.new.reportmail(:user => username)
      if response.success?
        say response.records.sort { |x,y| x[:email_name] <=> y[:email_name]}.to_ascii_table [:username, :internal_account_id, :email_type, :email_name, :email_destination], %w(Username ID Type Name Destination)
      else
        warn response.detail
      end
    end

    desc "group-add [postmaster@]example.com [password]", "Create a group account"
    def group_add (username, password = nil)
      username = "postmaster@#{username}" unless username =~ /@/
      last, first = username.split /@/
      password ||= ActiveSupport::SecureRandom.hex
      response = Fusebox::Request.new.order(:account_type => 'standard', :user => username, :password => password, :first_name => first, :last_name => last)
      say response.detail
    end

    desc "ls [[postmaster@]example.com]", "List accounts. This will list all group accounts if argument is blank"
    method_options [:recursive, '-r'] => :boolean
    # @todo add flag for ignoring terminated accounts
    def ls (username = 'all')
      username = "postmaster@#{username}" unless username =~ /@/ || username == 'all'
      recursive = options[:recursive] || (username == 'all' ? false : true)
      response = Fusebox::Request.new.report(:user => username, :group_subaccount => recursive, :report_type => 'extended')
      if response.success?
        say response.records.sort { |x,y| x[:username] <=> y[:username]}.to_ascii_table([:username, :creation_date, :internal_account_id, :status, :disk_usage], %w(Username Created ID Status Disk))
      else
        warn response.detail
      end
    end

    desc "passwd user@example.com [newpassword]", "Change a user's password (will prompt if password left blank)"
    def passwd (username, password = nil)
      password = ask "New Password:" unless password
      response = Fusebox::Request.new.modify(:user => username, :password => password)
      say response.detail
    end

    desc "rename old@example.com new@example.com", "Rename an account's username"
    def rename (old_username, new_username)
      response = Fusebox::Request.new.changeusername(:user => old_username, :newuser => new_username)
      say response.detail
    end

    desc "rm user@example.com", "Terminate a user or group account immediately"
    method_options :purge => false
    method_options [:force, '-f'] => false
    def rm (username)
      if options[:force] || yes?("Are you sure you want to remove user: #{username}? [y/N]")
        response = Fusebox::Request.new.terminate(:user => username, :purge => options[:purge])
        say response.detail
      else
        say "No action taken."
      end
    end

    desc "suspend user@example.com", "Suspend a user account"
    def suspend (username)
      response = Fusebox::Request.new.suspend(:user => username)
      say response.detail
    end
  end
end