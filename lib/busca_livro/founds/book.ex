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
    defaults [:destroy, :update]

    default_accept [:title, :price, :image_url, :url]

    action :count, :integer do
      run fn changeset, _context ->
        Ash.count(__MODULE__)
      end
    end

    create :create do
      primary? true

      change after_action(fn changeset, book, _ctx ->
               book = Ash.load!(book, :title_words)
               # mmelhor fazer um query e botar o filtro na db, talvez
               users = BuscaLivro.Accounts.list_users!(authorize?: false)

               Enum.each(users, fn user ->
                 if Enum.any?(user.wanted_words, &(&1 in book.title_words)) do
                   BuscaLivro.Founds.associate_wanted_book_to_user(book.id, user.id,
                     upsert?: true,
                     upsert_identity: :unique_found_book,
                     upsert_fields: [:book_id, :user_id],
                     authorize?: false
                   )
                 end
               end)

               {:ok, book}
             end)
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

  calculations do
    calculate :title_words,
              {:array, :string},
              expr(fragment("regexp_split_to_array(lower(?), '\\s+')", title))
  end

  identities do
    identity :unique_url, [:url]
  end
end
