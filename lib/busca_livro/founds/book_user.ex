defmodule BuscaLivro.Founds.BookUser do
  use Ash.Resource,
    otp_app: :busca_livro,
    domain: BuscaLivro.Founds,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication]

  postgres do
    table "book_users"
    repo BuscaLivro.Repo
  end

  actions do
    defaults [:destroy, :create, :update]
    default_accept [:book_id, :user_id]

    read :read do
      primary? true

      pagination offset?: true, keyset?: true, required?: false

      prepare build(load: [:book])
      filter expr(user_id == ^actor(:id))
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if actor_present()
    end
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
