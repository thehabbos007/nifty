defmodule Nifty.Faas.Router do
  use Plug.Router

  alias Nifty.Faas.HandlerSupervisor

  plug(Plug.Static, at: "/", from: :nifty)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json, :multipart],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/list" do
    routes = HandlerSupervisor.list_routes()

    html_response =
      """
      <html>
        <body>
          <h1>Routes</h1>
          <ul>
            #{Enum.map(routes, fn {k, _v} -> "<li><a href='/api/#{k}'>#{k}</a></li>" end) |> Enum.join()}
          </ul>
        </body>
      </html>
      """

    send_resp(conn, 200, html_response)
  end

  post "/upload" do
    with verb <- Map.get(conn.params, "verb"),
         route <- Map.get(conn.params, "route"),
         %Plug.Upload{path: path} <- Map.get(conn.params, "file") do
      bytes = File.read!(path)

      HandlerSupervisor.start_child(route, bytes, %{"verb" => verb, "route" => route})

      conn
      |> resp(:found, "")
      |> put_resp_header("location", "/list")
    else
      {:error, _} -> error(conn, "No config provided")
      nil -> error(conn, "No file uploaded")
      x -> error(conn, "Malformed config #{x}")
    end
    |> halt()
  end

  match "/api/*path" do
    response =
      Enum.join(path, "/")
      |> HandlerSupervisor.find_route()
      |> IO.inspect()
      |> HandlerSupervisor.execute(conn.params)

    jsonify(conn, 200, response)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp error(conn, message) do
    conn |> jsonify(400, %{"error" => message})
  end

  defp jsonify(conn, code, json) do
    conn
    |> update_resp_header(
      "content-type",
      "application/json; charset=utf-8",
      &(&1 <> "; charset=utf-8")
    )
    |> send_resp(code, Jason.encode!(json))
  end
end
