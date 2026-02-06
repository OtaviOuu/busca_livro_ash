defmodule BuscaLivro.Scraper do
  use Ash.Domain,
    otp_app: :busca_livro

  resources do
    resource BuscaLivro.Scraper.EstanteVirtual do
      define :scrape_estante_virtual_books, action: :scrape
    end
  end
end
