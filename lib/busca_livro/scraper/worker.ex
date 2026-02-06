defmodule BuscaLivro.Scraper.Worker do
  use Oban.Worker, queue: :default, max_attempts: 3

  def perform(_job) do
    case BuscaLivro.Scraper.scrape_estante_virtual_books() do
      {:ok, books_attrs} ->
        dbg(
          Ash.bulk_create(books_attrs, BuscaLivro.Founds.Book, :create,
            upsert?: true,
            upsert_identity: :unique_url,
            upsert_fields: [:title, :authors, :price, :cover_url]
          )
        )

        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end
end
