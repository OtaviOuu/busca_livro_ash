defmodule BuscaLivro.Founds.Plataform do
  use Ash.Resource,
    otp_app: :busca_livro,
    domain: BuscaLivro.Founds,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "plataforms"
    repo BuscaLivro.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:name]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :atom do
      allow_nil? false
      constraints one_of: [:estante_virtual, :shopee]
    end

    timestamps()
  end
end
