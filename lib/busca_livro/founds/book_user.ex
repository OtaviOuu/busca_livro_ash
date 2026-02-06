defmodule BuscaLivro.Founds.BookUser do
  use Ash.Resource,
    otp_app: :busca_livro,
    domain: BuscaLivro.Founds,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "book_users"
    repo BuscaLivro.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  relationships do
    belongs_to :book, BuscaLivro.Founds.Book do
      source_attribute :book_id
      destination_attribute :id
    end

    belongs_to :user, BuscaLivro.Accounts.User do
      source_attribute :user_id
      destination_attribute :id
    end
  end
end
