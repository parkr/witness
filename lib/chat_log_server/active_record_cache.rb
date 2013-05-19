module ChatLogServer
  module ActiveRecordCache
    def self.included(klass)
      def klass.enable_query_caching
        self.connection.instance_variable_set(:@query_cache_enabled, true)
        self.connection.instance_variable_set(:@query_cache, {})
      end
      def klass.disable_query_caching
        self.connection.instance_variable_set(:@query_cache_enabled, false)
      end
    end
  end
end
