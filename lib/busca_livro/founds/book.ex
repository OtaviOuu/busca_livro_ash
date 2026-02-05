defmodule BuscaLivro.Founds.Book do
  use Ash.Resource,
    otp_app: :busca_livro,
    domain: BuscaLivro.Founds,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "books"
    repo BuscaLivro.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :title, :string do
      allow_nil? false
    end

    attribute :description, :string do
      allow_nil? false
    end

    attribute :price, :money do
      allow_nil? false
    end

    timestamps()
  end
end
