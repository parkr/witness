module ChatLogServer
  module Helpers
    module Paths
      def erb_path(path)
        if path.match(/^\/$/)
          "index.erb"
        else
          if !path.match(/\.erb$/)
            "#{path.gsub(File.extname(path), '')}.erb"
          else
            path
          end
        end
      end

      def scss_path(path)
        File.basename(path.gsub(/\.css$/, '.scss'))
      end

      def static_path(path)
        if path =~ /\/$/
          "#{path}/index.html"
        else
          path
        end
      end
    end
  end
end
