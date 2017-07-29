defmodule BardBackend.WebpackProxy do
  use Plug.Router
  plug :match
  plug :dispatch
  forward "/", to: ReverseProxy, upstream: ["127.0.0.1:3000"]
end
