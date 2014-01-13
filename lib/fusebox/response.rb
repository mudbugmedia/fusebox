require 'csv' # We're favoring the stdlib csv in favor of not adding dependencies

module Fusebox
  # @see http://www.fusemail.com/support/administration-api/httphttps-response Fusemail Response documentation
  class Response

    # @return [Net::HTTPOK]
    attr_reader :http_response

    # @return [Fixnum] Numeric code # of
    attr_reader :code

    # @return [String] Human-readable description of response, corresponding to {#code}
    attr_reader :detail

    # @return [Array<Hash>] Array of records returned by query-type commands, e.g. 'report'
    attr_reader :records

    # Column name mapping for CSV data returned by report and reportmail request types
    CSV_MAPS = {
      :report_basic => [
        :username,
        :internal_account_id,
        :status,
        :password,
        :account_plan
      ],

      :report_extended => [
        :username,
        :internal_account_id,
        :status,
        :password,
        :account_plan,
        :creation_date,
        :first_name,
        :last_name,
        :company_name,
        :street_1,
        :street_2,
        :city,
        :state,
        :phone,
        :disk_usage
      ],

      :reportmail => [
        :username,
        :internal_account_id,
        :email_type,
        :email_name,
        :email_destination
      ]
    }

    # @param [Net::HTTPOK] http_response Response from {Net::HTTP.post_form_with_ssl}
    # @param [Fusebox::Request::CSV_MAPS.keys] result_map_type Which CSV_MAPS to use to map map column names of CSV results (for report and reportmail types)
    def initialize (http_response, result_map_type = nil)
      @http_response = http_response
      records = http_response.body.split(/[\r\n]/)
      code, @detail = records.shift.split('||')
      @code = code.to_i

      if result_map_type
        raise ArgumentError, "result_map_type: #{result_map_type} does not exist in CSV_MAPS" unless CSV_MAPS[result_map_type]
        @records = records.map do |line|
          Hash[CSV_MAPS[result_map_type].zip(CSV.parse_line(line))]
        end
      end

    end

    # @return [Boolean]
    def success?
      @code == 1
    end

  end
end