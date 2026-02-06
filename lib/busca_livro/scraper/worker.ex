defmodule BuscaLivro.Scraper.Worker do
  use Oban.Worker, queue: :default, max_attempts: 3

  def perform(_job) do
    case BuscaLivro.Scraper.scrape_estante_virtual_books() do
      {:ok, result} ->
        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end
end
