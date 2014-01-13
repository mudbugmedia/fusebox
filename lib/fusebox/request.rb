require 'yaml'

module Fusebox
  # @see http://www.fusemail.com/support/administration-api
  class Request

    class << self
      # @return [Array<String>] Paths to search for API platform authentication information
      attr_accessor :auth_yaml_paths

      # @return [String] API URL to POST requests to
      attr_accessor :url
    end

    # @return [String] Platform API username
    attr_accessor :username

    # @return [String] Platform API password
    attr_accessor :password

    self.auth_yaml_paths = %w(~/.fusemail.yaml)
    self.url = 'https://www.fusemail.com/api/request.html'

    # @return [Array<String>] List of available API commands
    COMMANDS = %w(adddomain addforward changeusername checkalias checkdomain suspend enable getforward modify order terminate removealias removedomain removeforward report reportmail)

    # @param [String] username API username.  If not provided, auth_yaml_paths will be searched for authentication information instead.
    # @param [String] password API password
    def initialize (username = nil, password = nil)
      if username && password
        @username = username
        @password = password
      else
        load_auth_from_yaml
      end
    end

    # This request will add a domain to the specified account. The must be under your platform
    # @see https://www.fusemail.com/support/api-documentation/requests#adddomain adddomain API documentation
    # @param [Array] opts
    # @option opts [String] :domain The domain to add
    # @option opts [String] :user The account to add the domain to
    # @return [Response]
    def adddomain (opts)
      default_options = {
        :domain => '',
        :user => ''
      }

      opts.reverse_merge! default_options
      post 'adddomain', opts
    end

    # This request will add an email forwarder.
    # @see https://www.fusemail.com/support/api-documentation/requests#addforward addforward API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account to add forwarder to
    # @option opts [String] :forward_what Email address of forwarder
    # @option opts [String] :forward_to External email address that forwarder will send to
    # @return [Response]
    def addforward (opts)
      default_options = {
        :user => '',
        :forward_what => '',
        :forward_to => ''
      }

      opts.reverse_merge! default_options
      post 'addforward', opts
    end


    # This request will check the availability of an alias against the whole system. Remember to add an alias, the domain must belong to the platform or to that account.
    # @see https://www.fusemail.com/support/api-documentation/requests#checkalias checkalias API documentation
    # @param [Array] opts
    # @option opts [String] :alias The alias to check the availability of (e.g. user@example.com)
    # @return [Response]
    def checkalias (opts)
      default_options = {
        :alias => ''
      }

      opts.reverse_merge! default_options
      post 'checkalias', opts
    end

    # This request is used to change the an account's username
    # @see https://www.fusemail.com/support/api-documentation/requests#changeusername changeusername API documentation
    # @param [Array] opts
    # @param opts [String] :user Username of FuseMail account to modify
    # @param opts [String] :newuser New username of the account
    # @return [Response]
    def changeusername (opts)
      default_options = {
        :user => '',
        :newuser => ''
      }

      opts.reverse_merge! default_options
      post 'changeusername', opts
    end

    # This request will check the availability of a domain name. This only checks if the domain name is available on our system, it does not reflect registrar status.
    # @see https://www.fusemail.com/support/api-documentation/requests#checkdomain checkdomain API documentation
    # @param [Array] opts
    # @option opts [String] :domain The domain to check the availability of
    # @return [Response]
    def checkdomain (opts)
      default_options = {
        :domain => ''
      }

      opts.reverse_merge! default_options
      post 'checkdomain', opts
    end

    # This request is used to change the an account's username
    # @see https://www.fusemail.com/support/api-documentation/requests#suspend suspend API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account to modify
    # @return [Response]
    def suspend (opts)
      default_options = {
        :user => '',
      }

      opts.reverse_merge! default_options
      post 'suspend', opts
    end

    # The enable request allow you to activate an account under your platform or temporarily start access to the account. Below are the variables that are specific to this request.
    # @see https://www.fusemail.com/support/api-documentation/requests#enable enable API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account to enable
    # @return [Response]
    def enable (opts)
      default_options = {
        :user => ''
      }

      opts.reverse_merge! default_options
      post 'enable', opts
    end

    # This request will return the forward currently set on an alias in the {Response#detail} attribute
    # @see https://www.fusemail.com/support/api-documentation/requests#getforward getforward API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account where the forwarding alias resides
    # @option opts [String] :forward_what Alias for the forwarder
    # @return [Response]
    def getforward (opts)
      default_options = {
        :user => '',
        :forward_what => ''
      }

      opts.reverse_merge! default_options
      post 'getforward', opts
    end

    # This request is used to modify personal information, password, and the account plan of the account. Only send the variables you wish to modify. If a NULL variable is detected, no change will be made to the account.
    # @see https://www.fusemail.com/support/api-documentation/requests#modify modify API documentation
    # @param opts (see Fusemail::Request#order)
    # @return [Response]
    def modify (opts)
      default_options = {
      }

      opts.reverse_merge! default_options
      post 'modify', opts
    end

    # This is a request to submit a new order and create a new account under your Fused Platform account. Orders are processed within 5 minutes of request submission. Below are the variables that are specific to this type of request.
    # @see https://www.fusemail.com/support/api-documentation/requests#order order API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account to create
    # @option opts [String] :password Password of FuseMail account to create
    # @option opts [String] :first_name First name of person
    # @option opts [String] :last_name Last name of person
    # @option opts [String] :email Other contact email address
    # @option opts [String] :street Street Address of person
    # @option opts [String] :city City of Address of person
    # @option opts [String] :state State of Address of person
    # @option opts [String] :postal Postal Code of Address of person
    # @option opts [String] :country Country of Address of person
    # @option opts [String] :account_type ('group_subaccount') Type of account to create, possible options: personal_basic, personal_power, personal_ultimate, group_basic, group_power, group_ultimate, group_subaccount.  See 'Account Plans' under your platform account for the API name you use.
    # @option opts [String] :group_parent The username of the main group account that this sub-account belongs to. This field is only required when using a group_subaccount account_type.
    # @option opts [String] :maxdisk ('1000') The maximum amount of disk space an account can consume in Megabytes (MB) (mainly used for group_subaccount's), integer only.
    # @option opts [Array<String>] :alias This field contains additional aliases to add to this account upon order creation.
    # @return [Response]
    def order (opts)
      default_options = {
        :account_type => 'group_subaccount',
        :first_name => '',
        :last_name => '',
        :maxdisk => 1000
      }

      opts.reverse_merge! default_options
      post 'order', opts
    end

    # The terminate request is used to permanently remove an account and all of the account data associated with it. This operation cannot be reversed and therefore should be used with caution.
    # @see https://www.fusemail.com/support/api-documentation/requests#terminate terminate API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account to terminate
    # @option opts [Boolean] :purge (false) Will purge all data (such as removing the username) from our system. This process might take a few hours to complete.
    # @return [Response]
    def terminate (opts)
      default_options = {
        :user => '',
        :purge => false
      }

      opts.reverse_merge! default_options
      post 'terminate', opts
    end

    # This request will remove a single alias from a fusemail account
    # @see https://www.fusemail.com/support/api-documentation/requests#removealias removealias API documentation
    # @param [Array] opts
    # @option opts [String] :user FuseMail user to delete alias from
    # @option opts [String] :alias alias to delete (e.g. user@example.com )
    # @return [Response]
    def removealias (opts)
      default_options = {
        :user => '',
        :alias => ''
      }

      opts.reverse_merge! default_options
      post 'removealias', opts
    end

    # This request will remove a domain name and all its mail aliases, auto-responders, mailing lists & forwarders associated with it. Please see below for the specific requirements for this request.
    # @see https://www.fusemail.com/support/api-documentation/requests#removedomain removedomain API documentation
    # @param [Array] opts
    # @option opts [String]  :domain The domain to delete
    # @option opts [Boolean] :confirm (true) This must be set to true to confirm that you understand all aliases, auto-responders, mailing lists & forwarders with this domain will be permanently deleted.
    # @return [Response]
    def removedomain (opts)
      default_options = {
        :domain => '',
        :confirm => true
      }

      opts.reverse_merge! default_options
      post 'removedomain', opts
    end


    # This request will remove an existing email forwarder
    # @see https://www.fusemail.com/support/api-documentation/requests#removeforward removeforward API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account to remove forwarder to
    # @option opts [String] :forward_what Email address of forwarder
    # @option opts [String] :forward_to External email address that forwarder will send to
    # @return [Response]
    def removeforward (opts)
      default_options = {
        :user => '',
        :forward_what => '',
        :forward_to => ''
      }

      opts.reverse_merge! default_options
      post 'removeforward', opts
    end

    # This request will provide information about one or more accounts under your platform in CSV format
    # @see https://www.fusemail.com/support/api-documentation/requests#report report API documentation
    # @param [Array] opts
    # @option opts [String] :user ('all') The username you wish to query for information; you may also enter the username "all" to get information about all users under your platform
    # @option opts [Boolean] :group_subaccount (true) Provide information not only for the Group Administration account but also for the group sub-accounts under the Group Administration account
    # @option opts ['basic', 'extended'] :report_type ('basic') Level of detailed in returned results
    # @return [Response]
    def report (opts = {})
      default_options = {
        :user => 'all',
        :group_subaccount => true,
        :report_type => 'basic'
      }

      opts.reverse_merge! default_options
      post 'report', opts, "report_#{opts[:report_type]}".to_sym
    end

    # This request will provide information about mail aliases, forwarders, autoresponders, or mailing lists on one or more accounts under your platform in CSV format.
    # @see https://www.fusemail.com/support/api-documentation/requests#reportmail reportmail API documentation
    # @param [Array] opts
    # @option opts [String] :user ('all') The username you wish to query for information; you may also enter the username "all" to get information about all users under your platform
    # @option opts [Boolean] :group_subaccount (true) Provide information not only for the Group Administration account but also for the group sub-accounts under the Group Administration account
    # @option opts ['all', 'alias', 'forwarder', 'autorespond', 'mailinglist'] :report_type ('all')
    #   * 'all' = Provide aliases, forwarders, autoresponders, and mailing list info
    #   * 'alias' = Provide only alias information
    #   * 'forwarder' = Provide only fowarder information
    #   * 'autorespond' = Provide only autoresponder information
    #   * 'mailinglist' = Provide only mailing list information
    # @return [Response]
    def reportmail (opts = {})
      default_options = {
        :user => 'all',
        :group_subaccount => true,
        :report_type => 'all'
      }

      opts.reverse_merge! default_options
      post 'reportmail', opts, :reportmail
    end

    # The suspend request allow you to suspend an account under your platform or temporarily stop access to the account without deleting any of the accounts data. Below are the variables that are specific to this request.
    # @see https://www.fusemail.com/support/api-documentation/requests#suspend suspend API documentation
    # @param [Array] opts
    # @option opts [String] :user Username of FuseMail account to suspend
    # @return [Response]
    def suspend (opts)
      default_options = {
        :user => ''
      }

      opts.reverse_merge! default_options
      post 'suspend', opts
    end

protected

    # Load the platform authentication informaiton from a YAML file
    # @see Request.auth_yaml_paths
    def load_auth_from_yaml
      self.class.auth_yaml_paths.map { |path| File.expand_path(path) }.select { |path| File.exist?(path) }.each do |path|
        auth = YAML.load(File.read(path))
        @username = auth['username']
        @password = auth['password']
        return if @username && @password
      end

      raise "Could not locate a fusemail authentication file in locations: #{self.class.auth_yaml_paths.inspect}"
    end

    # @param [String] command
    # @param [Hash] post_vars
    # @param [Fusebox::Request::CSV_MAPS.keys, nil] result_map_type (nil) For commands that return CSV data, which column map to use
    # @return [Fusebox::Response]
    def post (command, post_vars, result_map_type = nil)
      post_vars.reverse_merge!(:PlatformUser => @username, :PlatformPassword => @password, :request => command)
      post_vars = self.class.convert_post_vars(post_vars)

      result = Net::HTTP.post_form_with_ssl(URI.parse(self.class.url), post_vars)
      Response.new(result, result_map_type)
    end

    # Convert non-string values in post vars to Fusemail's expected formatting
    # * Boolean => 'yes' or 'no'
    # * Array   => Remove 'foo' and create 'foo[0]', 'foo[1]'
    # @param [Hash] post_vars
    # @return [Hash] post_vars
    def self.convert_post_vars (post_vars)
      ret = {}
      post_vars.each_pair do |key, value|
        # Convert booleans to 'yes', 'no' strings
        if [TrueClass, FalseClass].include?(value.class)
          ret[key] = (value ? 'yes' : 'no')

        # Convert arrays into 'key[0]', 'key[1]', ...
        elsif value.class == Array
          value.each_with_index do |value, index|
            ret["#{key}[#{index}]"] = value
          end
        else
          ret[key] = value
        end
      end

      ret
    end

  end
end
