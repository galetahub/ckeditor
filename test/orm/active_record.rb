# frozen_string_literal: true

def activerecord_below_5_2?
  ActiveRecord.version.release() < Gem::Version.new('5.2.0')
end

if activerecord_below_5_2?
  ActiveRecord::Migrator.migrate('test/dummy/db/migrate')
else
  schema_migration = ActiveRecord::Base.connection.schema_migration
  ActiveRecord::MigrationContext.new('test/dummy/db/migrate', schema_migration).migrate
end
