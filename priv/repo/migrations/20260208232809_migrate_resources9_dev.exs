defmodule BuscaLivro.Repo.Migrations.MigrateResources9 do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE book_users
    DROP CONSTRAINT IF EXISTS book_users_pkey
    """)

    alter table(:book_users) do
      add :id, :uuid,
        null: false,
        default: fragment("uuid_generate_v7()"),
        primary_key: true
    end
  end

  def down do
    execute("""
    ALTER TABLE book_users
    DROP CONSTRAINT IF EXISTS book_users_pkey
    """)

    alter table(:book_users) do
      remove :id
    end
  end
end
