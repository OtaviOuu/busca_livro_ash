defmodule BuscaLivro.Scraper.Actions.ScrapeEstanteVirtualBooks do
  use Ash.Resource.Actions.Implementation

  require Logger

  @base_url "https://www.estantevirtual.com.br"

  @categories_url @base_url <> "/categoria"

  @query_filters_for_newest_used_books "?sort=new-releases&tipo-de-livro=usado"

  def run(_input, _opts, _ctx) do
    books_url =
      get_categories_urls()
      # |> Enum.take(5)
      |> get_all_books_urls_from_categories_urls()
      # |> Enum.take(10)
      |> get_all_books_data_from_urls()

    {:ok, books_url}
  end

  defp get_categories_urls do
    with {:ok, categories_html_tree} <- parse_html_from_url(@categories_url) do
      categories_html_tree
      |> Floki.find(".landing-page-estante")
      |> Floki.find(".menu_lista-estantes")
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.map(&build_books_newst_page_url/1)
    end
  end

  defp get_all_books_urls_from_categories_urls(categories_urls) do
    categories_urls
    |> Task.async_stream(&get_book_urls_from_category/1,
      max_concurrency: 50,
      timeout: :infinity
    )
    |> Enum.flat_map(fn {:ok, book_urls} -> book_urls end)
  end

  defp get_book_urls_from_category(category_url) do
    Logger.info("Getting book URLs from category: #{category_url}")

    with {:ok, category_html_tree} <- parse_html_from_url(category_url) do
      category_html_tree
      |> Floki.find("a.product-item__link")
      |> Floki.attribute("href")
      |> Enum.map(&build_book_url/1)
    end
  end

  defp get_all_books_data_from_urls(book_urls) do
    book_urls
    |> Task.async_stream(&get_book_data_from_url/1,
      max_concurrency: 50,
      timeout: :infinity
    )
    |> Enum.flat_map(fn {:ok, book_data} -> [book_data] end)
  end

  defp get_book_data_from_url(book_url) do
    Logger.info("Getting book data from URL: #{book_url}")

    with {:ok, book_html_tree} <- parse_html_from_url(book_url) do
      book_html_tree =
        book_html_tree
        |> Floki.find(".product-container")

      put_title_data(book_html_tree)
      |> put_price_data(book_html_tree)
      |> put_image_url_data(book_html_tree)
      |> Map.put(:url, book_url)
    end
  end

  defp put_title_data(book_data \\ %{}, book_page_html_tree) do
    title =
      book_page_html_tree
      |> Floki.find("h1.product-details__header--title")
      |> Floki.text()
      |> String.trim()

    Map.put(book_data, :title, title)
  end

  defp put_price_data(book_data, book_page_html_tree) do
    price_stirng =
      book_page_html_tree
      |> Floki.find(".book-copy__price__sale-price")
      |> Floki.text()
      |> String.trim()
      |> String.split("R$")
      |> List.last()
      |> String.replace(",", ".")

    Map.put(book_data, :price, price_stirng)
  end

  defp put_image_url_data(book_data, book_page_html_tree) do
    image_url =
      book_page_html_tree
      |> Floki.find(".pictures__carousel__item img")
      |> Floki.attribute("src")
      |> Floki.text()
      |> String.trim()

    Map.put(book_data, :image_url, image_url)
  end

  defp build_books_newst_page_url(categories_href),
    do: @base_url <> categories_href <> @query_filters_for_newest_used_books

  defp build_book_url(book_href), do: @base_url <> book_href

  defp parse_html_from_url(url) do
    with {:ok, response} <- Req.get(url),
         {:ok, categories_html} <- Map.fetch(response, :body),
         {:ok, categories_html_tree} <- Floki.parse_document(categories_html) do
      {:ok, categories_html_tree}
    end
  end
end
