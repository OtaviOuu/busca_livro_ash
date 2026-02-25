defmodule BuscaLivro.Accounts do
  use Ash.Domain,
    otp_app: :busca_livro,
    extensions: [AshJsonApi.Domain, AshAdmin.Domain, AshPhoenix]

  json_api do
    routes do
      base_route "/users", BuscaLivro.Accounts.User do
        post :register_with_password do
          route "/register"

          metadata fn _subject, user, _request ->
            %{token: user.__metadata__.token}
          end
        end

        post :sign_in_with_password do
          route "/sign-in"

          metadata fn _subject, user, _request ->
            %{token: user.__metadata__.token}
          end
        end
      end
    end
  end

  admin do
    show? true
  end

  resources do
    resource BuscaLivro.Accounts.Token

    resource BuscaLivro.Accounts.User do
      define :add_wanted_word, action: :add_wanted_word, args: [:new_word]
      define :list_users, action: :read
      define :get_user, action: :get_by_email
      define :remove_wanted_word, action: :remove_wanted_word, args: [:word]
    end
  end
end
