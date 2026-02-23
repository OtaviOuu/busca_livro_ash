defmodule BuscaLivroWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [BuscaLivro.Founds, BuscaLivro.Accounts],
    open_api: "/open_api"
end
