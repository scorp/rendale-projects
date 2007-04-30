# Author/Maintainer: Maik Schmidt <contact@maik-schmidt.de>

require 'active_record/connection_adapters/abstract_adapter'

begin
  require 'db2/db2cli' unless self.class.const_defined?(:DB2CLI)
  require 'active_record/vendor/db2'

  module ActiveRecord
    class Base
      # Establishes a connection to the database that's used by
      # all Active Record objects
      def self.db2_connection(config) # :nodoc:
        config = config.symbolize_keys
        usr = config[:username]
        pwd = config[:password]
        schema = config[:schema]

        if config.has_key?(:database)
          database = config[:database]
        else
          raise ArgumentError, 'No database specified. Missing argument: database.'
        end

        connection = DB2::Connection.new(DB2::Environment.new)
        connection.connect(database, usr, pwd)
        ConnectionAdapters::DB2Adapter.new(connection, logger, :schema => schema)
      end
    end

    module ConnectionAdapters
      # The DB2 adapter works with the C-based CLI driver (http://rubyforge.org/projects/ruby-dbi/)
      #
      # Options:
      #
      # * <tt>:username</tt> -- Defaults to nothing
      # * <tt>:password</tt> -- Defaults to nothing
      # * <tt>:database</tt> -- The name of the database. No default, must be provided.
      # * <tt>:schema</tt> -- Database schema to be set initially.
      class DB2Adapter < AbstractAdapter
        def initialize(connection, logger, connection_options)
          super(connection, logger)
          @connection_options = connection_options
          if schema = @connection_options[:schema]
            with_statement do |stmt|
              stmt.exec_direct("SET SCHEMA=#{schema}")
            end
          end
        end
        
        def select_all(sql, name = nil)
          select(sql, name)
        end

        def select_one(sql, name = nil)
          select(sql, name).first
        end

        def insert(sql, name = nil, pk = nil, id_value = nil, sequence_name = nil)
          execute(sql, name = nil)
          id_value || last_insert_id
        end

        def execute(sql, name = nil)
          rows_affected = 0
          with_statement do |stmt|
            log(sql, name) do
              stmt.exec_direct(sql)
              rows_affected = stmt.row_count
            end
          end
          rows_affected
        end

        alias_method :update, :execute
        alias_method :delete, :execute

        def begin_db_transaction
          @connection.set_auto_commit_off
        end

        def commit_db_transaction
          @connection.commit
          @connection.set_auto_commit_on
        end
        
        def rollback_db_transaction
          @connection.rollback
          @connection.set_auto_commit_on
        end

        def quote_column_name(column_name)
          column_name
        end

        def adapter_name()
          'DB2'
        end

        def quote_string(string)
          string.gsub(/'/, "''") # ' (for ruby-mode)
        end

        def add_limit_offset!(sql, options)
          if limit = options[:limit]
            offset = options[:offset] || 0
            # The following trick was added by andrea+rails@webcom.it.
            sql.gsub!(/SELECT/i, 'SELECT B.* FROM (SELECT A.*, row_number() over () AS internal$rownum FROM (SELECT')
            sql << ") A ) B WHERE B.internal$rownum > #{offset} AND B.internal$rownum <= #{limit + offset}"
          end
        end

        def tables(name = nil)
          result = []
          schema = @connection_options[:schema] || '%'
          with_statement do |stmt|
            stmt.tables(schema).each { |t| result << t[2].downcase }
          end
          result
        end

        def indexes(table_name, name = nil)
          tmp = {}
          schema = @connection_options[:schema] || ''
          with_statement do |stmt|
            stmt.indexes(table_name, schema).each do |t|
              next unless t[5]
              next if t[4] == 'SYSIBM' # Skip system indexes.
              idx_name = t[5].downcase
              col_name = t[8].downcase
              if tmp.has_key?(idx_name)
                tmp[idx_name].columns << col_name
              else
                is_unique = t[3] == 0
                tmp[idx_name] = IndexDefinition.new(table_name, idx_name, is_unique, [col_name])
              end
            end
          end
          tmp.values
        end

        def columns(table_name, name = nil)
          result = []
          schema = @connection_options[:schema] || '%'
          with_statement do |stmt|
            stmt.columns(table_name, schema).each do |c| 
              c_name = c[3].downcase
              c_default = c[12] == 'NULL' ? nil : c[12]
              c_default.gsub!(/^'(.*)'$/, '\1') if !c_default.nil?
              c_type = c[5].downcase
              c_type += "(#{c[6]})" if !c[6].nil? && c[6] != ''
              result << Column.new(c_name, c_default, c_type, c[17] == 'YES')
            end 
          end
          result
        end

        def native_database_types
          {
            :primary_key => 'int generated by default as identity (start with 42) primary key',
            :string      => { :name => 'varchar', :limit => 255 },
            :text        => { :name => 'clob', :limit => 32768 },
            :integer     => { :name => 'int' },
            :float       => { :name => 'float' },
            :datetime    => { :name => 'timestamp' },
            :timestamp   => { :name => 'timestamp' },
            :time        => { :name => 'time' },
            :date        => { :name => 'date' },
            :binary      => { :name => 'blob', :limit => 32768 },
            :boolean     => { :name => 'decimal', :limit => 1 }
          }
        end

        def quoted_true
          '1'
        end

        def quoted_false
          '0'
        end

        def active?
          @connection.select_one 'select 1 from ibm.sysdummy1'
          true
        rescue Exception
          false
        end

        def reconnect!
        end

        def table_alias_length
          128
        end

        private

        def with_statement
          stmt = DB2::Statement.new(@connection)
          yield stmt
          stmt.free
        end

        def last_insert_id
          row = select_one(<<-GETID.strip)
          with temp(id) as (values (identity_val_local())) select * from temp
          GETID
          row['id'].to_i
        end

        def select(sql, name = nil)
          rows = []
          with_statement do |stmt|
            log(sql, name) do
              stmt.exec_direct("#{sql.gsub(/=\s*null/i, 'IS NULL')} with ur")
            end

            while row = stmt.fetch_as_hash
              row.delete('internal$rownum')
              rows << row
            end
          end
          rows
        end
      end
    end
  end
rescue LoadError
  # DB2 driver is unavailable.
  module ActiveRecord # :nodoc:
    class Base
      def self.db2_connection(config) # :nodoc:
        # Set up a reasonable error message
        raise LoadError, "DB2 Libraries could not be loaded."
      end
    end
  end
end
