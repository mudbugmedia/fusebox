module Net
  class HTTP
    # Posts HTML form data to the URL, but allow for SSL.
    #
    # The existing 1.8.x implementaiton via post_form does not allow for SSL connections
    #
    # @param [URI] url
    # @param [Hash] POST data
    def HTTP.post_form_with_ssl(url, params)
      req = Post.new(url.path)
      req.form_data = params
      req.basic_auth url.user, url.password if url.user
      http = new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      http.start {|http|
        http.request(req)
      }      
    end
  end
end