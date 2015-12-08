class AddPgSearchExtensions < ActiveRecord::Migration
  def change
    execute "create extension if not exists unaccent"
    execute "create extension if not exists pg_trgm"
  end
end
