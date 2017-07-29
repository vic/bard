defmodule BardBackend.Endpoint do
  use Phoenix.Endpoint, otp_app: :bard_backend
  socket "/socket", BardBackend.Socket

  plug BardBackend.WebpackProxy
end
