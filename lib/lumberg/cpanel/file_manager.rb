module Lumberg
  module Cpanel
    # Public: This module provides access to file functions such as listing
    # directories and viewing files.
    class FileManager < Base
      def self.api_module; "Fileman"; end

      # Public: list files and attributes contained within a specified
      # directory
      #
      # options   - Hash options for API call params (default: {})
      #   :check_leaf - Boolean value of "1" will cause the function to add
      #                 "isleaf" parameter to the output key, e.g: true value
      #                 (1) indicates a directory that has no subdirectories
      #                 (default: '')
      #
      #   :directory - String directory that contains the files you wish to
      #                browse, and '/' represents your home directory.
      #                (default: 'your home directory')
      #
      #   :list - A Boolean value of "1" indicates the function to look for
      #           keys that begin with "filepath-*". These keys are used to
      #           indicate specific files to list (default: '')
      #
      #   :path - String parameter allows you to specify files you want listed
      #           with the output if :list is set to "1". This can be any
      #           number of parameters such as "filelist-A", "filelist-B", etc.
      #           Each of these keys indicate a file you wish to view
      #           (default:'')
      #
      #   :need_mime - A Boolean value of "1" indicates that you would like the
      #                function to add the 'mimename' and 'mimetype' to output
      #                (default: '')
      #
      #
      #   :show_dot_files - A Boolean value of "1" indicates that you'd like
      #                     the function to add dotfiles to output
      #                     (default: '')
      #
      #   :types - String filter allowing you to specify which file types you
      #            wish to view. Acceptable values include "dir", "file" and
      #            "special". Separate each type using a pipe (|) to add
      #            multiple values. (default: '')
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   file_manager = Lumberg::Cpanel::FileManager.new(api_args.dup)
      #
      #   file_manager.list
      #
      # Returns Hash API response.
      def list(options = {})
        options[:dir]          = options.delete(:directory)
        options[:filelist]     = options.delete(:list)
        options[:filepath]     = options.delete(:path)
        options[:needmime]     = options.delete(:need_mime)
        options[:checkleaf]    = options.delete(:check_leaf)
        options[:showdotfiles] = options.delete(:show_dot_files)

        perform_request({ api_function: 'listfiles' }.merge(options))
      end

      # Public: View a file within your home directory. This function also
      # display additional information about the file such as the contents of a
      # tarball, a link to an image and more
      #
      # options - Hash options for API call params (default: {})
      #   :directory - String directory in which the file is located. Path must
      #                be relative to user's home, e.g: 'public_html/files/'
      #                (default: '')
      #   :file - String path to the file you wish to view
      #
      # Returns Hash API response.
      def show(options = {})
        options[:dir] = options.delete(:directory)

        perform_request({ api_function: 'viewfile' }.merge(options))
      end

      # Public: Retrieve information about specific files
      #
      # options - Hash options for API call params (default: {})
      #   :directory - String directory whose files you wish to review, (e.g:
      #                /home/user/public_html/files). (default: 'your home')
      #
      #   :file - String name of the file whose statistics you wish to review.
      #           You may define multiple files by separating each value with a
      #           pipe, e.g: 'file1|file2|file3'
      #
      # Returns Hash API response.
      def stat(options = {})
        options[:dir] = options.delete(:directory)

        perform_request({ api_function: 'statfiles' }.merge(options))
      end

      # Public: Retrieve disk usage statistics about your account.
      #
      # Returns Hash API response.
      def disk_usage
        perform_request({ api_function: 'getdiskinfo' })
      end

      # Public: Perform an operation on a file or group of files. You can use
      # this function to copy, move, rename, chmod, extract and compress, link
      # and unlink, and trash files and directories.
      #
      # options - Hash options for API call params (default: {})
      #   :name - String naming the operation to perform. Acceptable values
      #           include 'copy', 'move', 'rename', 'chmod', 'extract',
      #           'compress', 'link', 'unlink', and 'trash' (move to .trash
      #           directory)
      #   :source_files - String files on which you wish to perform the
      #                   operation. You can include multiple files by
      #                   separating each file with a comma (,). Do not add
      #                   spaces.
      #   :destination_files - String list of destination filenames. If
      #                        multiple sourcefiles are listed with multiple
      #                        destination files ('destfiles'), the function
      #                        attempts to handle each transaction on a 1-to-1
      #                        basis. If only 1 file is specified in
      #                        'sourcefiles', it will be moved, or copied, or
      #                        etc. to the first directory listed.
      #   :decode_uri - Boolean value. Entering '1' will cause the function to
      #                 decode the URI-encoded variables :source_files and
      #                 :destination_files
      #   :metadata - String parameter which contains any added values required
      #               by the named operation. When using 'compress', tihs would
      #               be the archive type. Acceptable values for the compress
      #               operation include: tar, gz, bz2, zip, tar.gz and tar.bz2.
      #               The chmod operation requires octal octal permissions like
      #               0755 or 0700.
      #
      # Returns Hash API response
      def operate(options={})
        options[:op] = options.delete(:name)
        options[:doubledecode] = options.delete(:decode_uri)
        options[:sourcefiles] = options.delete(:source_files)
        options[:destfiles] = options.delete(:destination_files)

        perform_request({ api_function: "fileop" }.merge(options))
      end
    end
  end
end

