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

    attribute :price, :money do
      allow_nil? false
    end

    attribute :image_url, :string do
      allow_nil? false
    end

    timestamps()
  end

  relationships do
    belongs_to :platform, BuscaLivro.Founds.Plataform do
      source_attribute :platform_id
      destination_attribute :id
      allow_nil? false
    end
  end
end
