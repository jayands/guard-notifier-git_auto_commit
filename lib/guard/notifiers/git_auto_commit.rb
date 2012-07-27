module Guard
  module Notifier
    module GitAutoCommit
      VERSION = "0.1.0"

      extend self

      # Test if the current directory is managed using git.
      #
      # @param [Boolean] silent true if no error messages should be shown
      # @return [Boolean] the availability status
      #
      def available?(silent = false)
        system("git status > /dev/null 2> /dev/null")
      end

      # Show a system notification.
      #
      # @param [String] type the notification type. Either 'success', 'pending', 'failed' or 'notify'
      # @param [String] title the notification title
      # @param [String] message the notification message body
      # @param [String] image the path to the notification image
      # @param [Hash] options additional notification library options
      # @option options [Boolean] sticky make the notification sticky
      # @option options [String, Integer] priority specify an int or named key (default is 0)
      #
      def notify(type, title, message, image, options = { })
        commit_message = [type, title, message].join('  ').gsub(/\r|\n/, '')
        commit_message << "\n\n"
        commit_message << `git diff --cached`
        system("git add -u")
        File.popen("git commit -F -", "r+") do |fd|
          fd.write commit_message
          fd.close
        end
      end
    end
  end
end