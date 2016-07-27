defmodule Calculador.RoomChannel do
  use Phoenix.Channel

  def join("room:calculador", _auth_message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _room_id, _auth_message, socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{ "body" => body }, socket) do
    msg_out = 
      case String.last(body) do
        "=" ->
          case res = Calculador.Operador.calculate(body) do
            :error -> ""
            _ -> res
          end
        _ -> body
      end

    broadcast! socket, "new_msg", %{body: msg_out}
    {:noreply, socket}
  end
end
