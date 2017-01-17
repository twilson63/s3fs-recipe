# Define S3FS module, to give us a good namespace.
module S3FS
  # Utility module with some helper functions.
  module Helper
    require 'uri'

    # Stolen from https://github.com/chef-cookbooks/jenkins/blob/master/libraries/_helper.rb#L80-L92
    # @param [Array<String>] parts
    #   the list of parts to join
    #
    def uri_join(*parts)
      parts = parts.compact.map(&URI.method(:escape))
      URI.parse(parts.join('/')).normalize.to_s
    end

    # returns the fuse folder path, because they moved to
    # github and put multiple releases under 1 github release path
    def get_release_path(version)
      fuse_version_string = if version.delete('.').to_i >= 295
                              "fuse_#{version.tr('.', '_')}"
                            else
                              'fuse_2_9_4'
                            end
      fuse_version_string
    end
  end
end
