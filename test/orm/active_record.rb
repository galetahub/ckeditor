# frozen_string_literal: true

def activerecord_below?(version)
  ActiveRecord.version.release < Gem::Version.new(version)
end

if activerecord_below?('5.2.0')
  ActiveRecord::Migrator.migrate('test/dummy/db/migrate')
elsif activerecord_below?('7.0.0')
  schema_migration = ActiveRecord::Base.connection.schema_migration
  ActiveRecord::MigrationContext.new('test/dummy/db/migrate', schema_migration).migrate
else
  ActiveRecord::MigrationContext.new('test/dummy/db/migrate').migrate
end
