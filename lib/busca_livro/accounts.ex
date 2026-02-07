defmodule BuscaLivro.Accounts do
  use Ash.Domain, otp_app: :busca_livro, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource BuscaLivro.Accounts.Token

    resource BuscaLivro.Accounts.User do
      define :add_wanted_word, action: :add_wanted_word, args: [:new_word]
      define :list_users, action: :read
    end
  end
end
