defmodule BuscaLivro.Founds.Book do
  use Ash.Resource,
    otp_app: :busca_livro,
    domain: BuscaLivro.Founds,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  json_api do
    type "book"
  end

  postgres do
    table "books"
    repo BuscaLivro.Repo
  end

  actions do
    defaults [:destroy, :update]

    default_accept [:title, :price, :image_url, :url]

    action :count, :integer do
      run fn changeset, _context ->
        Ash.count(__MODULE__)
      end
    end

    read :read_achados do
      pagination offset?: true, keyset?: true, required?: false
      filter expr(users.id == ^actor(:id))
    end

    create :create do
      primary? true

      change BuscaLivro.Founds.Changes.AssociateWantedBookToUser
    end

    read :read do
      primary? true
      prepare build(load: [:title_words])
      pagination offset?: true, keyset?: true, required?: false
    end

    read :search do
      argument :book_name, :string do
        allow_nil? false
      end

      filter expr(ilike(title, "%" <> ^arg(:book_name) <> "%"))

      pagination offset?: true, keyset?: true, required?: false
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :title, :string do
      allow_nil? false
      public? true
    end

    attribute :price, :money do
      allow_nil? false
      public? true
    end

    attribute :image_url, :string do
      allow_nil? false
      public? true
    end

    attribute :url, :string do
      allow_nil? false
      public? true
    end

    timestamps(public?: true)
  end

  relationships do
    many_to_many :users, BuscaLivro.Accounts.User do
      through BuscaLivro.Founds.BookUser
      source_attribute_on_join_resource :book_id
      destination_attribute_on_join_resource :user_id
    end
  end

  calculations do
    calculate :title_words,
              {:array, :string},
              expr(fragment("regexp_split_to_array(lower(?), '\\s+')", title)),
              public?: true
  end

  identities do
    identity :unique_url, [:url]
  end
end
