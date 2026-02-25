defmodule BuscaLivro.Founds do
  use Ash.Domain,
    otp_app: :busca_livro,
    extensions: [AshJsonApi.Domain, AshAdmin.Domain, AshPhoenix]

  json_api do
    routes do
      base_route "/books", BuscaLivro.Founds.Book do
        index :read
      end

      base_route "/achados", BuscaLivro.Founds.BookUser do
        index :read
      end
    end
  end

  admin do
    show? true
  end

  resources do
    resource BuscaLivro.Founds.Book do
      define :create_book, action: :create
      define :list_books, action: :read
      define :list_achados, action: :read_achados

      define :get_book, action: :read, get_by: :id
      define :search_books, action: :search, args: [:book_name]

      define :count_books, action: :count
    end

    resource BuscaLivro.Founds.Plataform

    resource BuscaLivro.Founds.BookUser do
      define :delete_found_book, action: :destroy
      define :get_found_book, action: :read, get_by: :user_id
      define :associate_wanted_book_to_user, action: :create, args: [:book_id, :user_id]
    end
  end
end
