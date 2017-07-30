defmodule Bard.Handler.DSL do

  @moduledoc """
  An small DSL for defining event handlers.

  Handlers syntax is as follows:

    {:on, [click: &some_func/1]}

  Bard.js will install an handler function in
  the component that will invoke `some_func/1`
  on the server.

  See `on/1` for examples.
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @doc """
  Define event handlers.

  handlers is a keyword whose values are
  partially applied pipes.

     on(textChanged: validate)

  or

     on(click: foo(:hello, bard))

  which expands to:

     {:on, [click: fn payload -> payload |> foo(:hello, bard) end]}

  """
  defmacro on(handlers) when is_list(handlers) do
    handlers = Enum.map(handlers, fn
      {k, v} -> {k, quote(do: fn x -> x |> unquote(v) end)}
    end)
    {:on, handlers}
  end

end
