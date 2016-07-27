defmodule Calculador.SessionPlug do
  @moduledoc """
  A plug that assigns :current_user and :user_token to conn.
  It should be initialized with the repo.
  """

  import Plug.Conn

  def init(repo: repo), do: repo

  def call(conn, repo) do
    current_user_id = get_session(conn, :current_user_id)

    if user = current_user_id && repo.get(Calculador.User, current_user_id) do
      put_current_user(conn, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

end
