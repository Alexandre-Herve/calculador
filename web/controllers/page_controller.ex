defmodule Calculador.PageController do
  use Calculador.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
