defmodule AuthyWeb.Auth.Guardian do
  use Guardian, otp_app: :authy

  alias Authy.Accounts
  alias Authy.Accounts.User
  alias Authy.Repo
  alias Argon2
  import Ecto.Query, only: [from: 2]

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end

  def authenticate(%{"id" => id, "password" => password}) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> validate_password(password, user)
    end
  end

  def authenticate(%{"email" => email, "password" => password}) do
    query = from u in User, where: u.email == ^email

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      user ->
        validate_password(password, user)
    end
  end

  defp validate_password(password, user) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> create_token(user)
      false -> {:error, :unauthorized}
    end
  end

  defp create_token(%User{} = user) do
    with {:ok, token, _claims} = encode_and_sign(user) do
      {:ok, token}
    end
  end
end
