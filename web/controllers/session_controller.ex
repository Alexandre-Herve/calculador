defmodule Calculador.SessionController do
  use Calculador.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Calculador.Session.login(session_params, Calculador.Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Logged In")
        |> redirect(to: "/")
      _ ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
