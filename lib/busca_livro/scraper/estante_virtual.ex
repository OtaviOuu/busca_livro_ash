defmodule BuscaLivro.Scraper.EstanteVirtual do
  use Ash.Resource,
    otp_app: :busca_livro,
    domain: BuscaLivro.Scraper,
    extensions: [AshOban]

  actions do
    action :scrape, {:array, :map} do
      run BuscaLivro.Scraper.Actions.ScrapeEstanteVirtualBooks
    end
  end
end
