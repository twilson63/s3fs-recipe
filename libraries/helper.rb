module S3FS
  module Helper
  require 'uri'
  #Stolen from https://github.com/chef-cookbooks/jenkins/blob/master/libraries/_helper.rb#L80-L92
  # @param [Array<String>] parts
  #   the list of parts to join
  #
  def uri_join(*parts)
    parts = parts.compact.map(&URI.method(:escape))
    URI.parse(parts.join('/')).normalize.to_s
  end
  end
end
