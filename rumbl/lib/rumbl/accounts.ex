defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(attrs) do
    Repo.get_by(User, attrs)
  end

  def change_user(%User{} = user) do
    User.base_changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.base_changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user) do
    User.registration_changeset(user, %{})
  end

  def change_login(%User{} = user, attrs \\ %{}) do
    User.login_changeset(user, attrs)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs \\ %{}) do
    user
    |> User.edit_profile_changeset(attrs)
    |> Repo.update()
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    get_user_by(username: username)
    |> authenticate_by_user_and_pass(given_pass)
  end

  def authenticate_by_user_and_pass(nil, _given_pass) do
    Pbkdf2.no_user_verify()
    {:error, :not_found}
  end

  def authenticate_by_user_and_pass(%User{} = user, given_pass) do
    case Pbkdf2.verify_pass(given_pass, user.password_hash) do
      true ->
        {:ok, user}
      false ->
        {:error, :unauthorized}
    end
  end
end
