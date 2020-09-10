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
end
