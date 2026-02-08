defmodule BuscaLivro.Founds do
  use Ash.Domain,
    otp_app: :busca_livro,
    extensions: [AshAdmin.Domain, AshPhoenix]

  admin do
    show? true
  end

  resources do
    resource BuscaLivro.Founds.Book do
      define :create_book, action: :create
      define :list_books, action: :read
      define :get_book, action: :read, get_by: :id
      define :search_books, action: :search, args: [:book_name]
      define :count_books, action: :count
    end

    resource BuscaLivro.Founds.Plataform

    resource BuscaLivro.Founds.BookUser do
      define :list_achados, action: :read
      define :associate_wanted_book_to_user, action: :create, args: [:book_id, :user_id]
    end
  end
end
