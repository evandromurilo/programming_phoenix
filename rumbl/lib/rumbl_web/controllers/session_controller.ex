defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  alias Rumbl.Accounts.User

  def new(conn, _attrs) do
    changeset = Rumbl.Accounts.change_login(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => session_attrs}) do
    changeset = Rumbl.Accounts.change_login(%User{}, session_attrs)

    case Ecto.Changeset.apply_action(changeset, :create) do
      {:ok, _user} ->
        case Rumbl.Accounts.authenticate_by_username_and_pass(
              session_attrs["username"],
              session_attrs["password"]
            ) do
          {:ok, user} ->
            conn
            |> RumblWeb.Auth.login(user)
            |> put_flash(:info, "Welcome back!")
            |> redirect(to: Routes.page_path(conn, :index))

          {:error, _why} ->
            conn
            |> put_flash(:error, "Invalid username/password combination.")
            |> render("new.html", changeset: Rumbl.Accounts.change_login(%User{}))
        end

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _attrs) do
    conn
    |> RumblWeb.Auth.logout()
    |> put_flash(:info, "See ya!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
