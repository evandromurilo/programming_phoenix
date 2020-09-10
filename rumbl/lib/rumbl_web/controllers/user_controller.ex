defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  def index(conn, _attrs) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _attrs) do
    changeset = Accounts.change_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_attrs}) do
    case Accounts.register_user(user_attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    changeset = Accounts.change_registration(user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_attrs}) do
    user = Accounts.get_user(id)

    case Accounts.update_user(user, user_attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated!")
        |> redirect(to: Routes.user_path(conn, :show, id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
