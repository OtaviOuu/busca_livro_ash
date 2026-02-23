defmodule BuscaLivro.Scraper.Worker do
  use Oban.Worker, queue: :default, max_attempts: 10

  require Logger

  def perform(_job) do
    Logger.info("Starting book scraping...")

    case BuscaLivro.Scraper.scrape_estante_virtual_books() do
      {:ok, books_attrs} ->
        books_attrs =
          books_attrs
          |> Enum.uniq_by(& &1.url)

        Logger.info("Scraped #{length(books_attrs)} unique books. Inserting into database...")

        Ash.bulk_create(books_attrs, BuscaLivro.Founds.Book, :create,
          upsert?: true,
          upsert_identity: :unique_url,
          upsert_fields: [:title, :authors, :price, :cover_url],
          return_records?: false
        )

        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end
end
