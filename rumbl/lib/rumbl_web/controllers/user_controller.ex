defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  plug :authenticate when action in [:index, :show]

  defp authenticate(conn, _opts) do
    case conn.assigns.current_user do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access that page.")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()

      _user ->
        conn
    end
  end

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
        |> RumblWeb.Auth.login(user)
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
