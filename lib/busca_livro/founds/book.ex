defmodule BuscaLivro.Founds.Book do
  use Ash.Resource,
    otp_app: :busca_livro,
    domain: BuscaLivro.Founds,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "books"
    repo BuscaLivro.Repo
  end

  actions do
    defaults [:destroy, :create]

    default_accept [:title, :price, :image_url, :url]

    read :read do
      primary? true

      pagination offset?: true, keyset?: true, required?: false
    end

    read :search do
      argument :book_name, :string do
        allow_nil? false
      end

      filter expr(
               ilike(title, "%" <> ^arg(:book_name) <> "%") or
                 ilike(url, "%" <> ^arg(:book_name) <> "%")
             )

      pagination offset?: true, keyset?: true, required?: false
    end
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

    attribute :url, :string do
      allow_nil? false
    end

    timestamps()
  end

  relationships do
    many_to_many :users, BuscaLivro.Accounts.User do
      through BuscaLivro.Founds.BookUser
      source_attribute_on_join_resource :book_id
      destination_attribute_on_join_resource :user_id
    end
  end

  identities do
    identity :unique_url, [:url]
  end
end
