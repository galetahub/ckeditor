# frozen_string_literal: true

ActiveRecord::Migrator.migrate(File.expand_path("../../dummy/db/migrate/", __FILE__))
