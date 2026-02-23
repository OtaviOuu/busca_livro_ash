defmodule BuscaLivroWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [BuscaLivro.Founds],
    open_api: "/open_api"
end
