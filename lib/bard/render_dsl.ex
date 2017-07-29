defmodule Bard.Render.DSL do

  @moduledoc """
  A tiny DSL for rendering components with Elixir syntax.

  In Bard nodes are represented by the
  Elixir tuple:

     {Tag, properties}

  Where Tag is an atom and properties is a map or
  a keyword list.

  The `r` macro is provided as a convenience,
  for example:

     iex> use Bard.Render.DSL
     iex> r(Button, "Hello")
     {Button, children: ["Hello"]}

     iex> use Bard.Render.DSL
     iex> r(Button, [:primary]) do
     ...>   "Hola"
     ...> end
     {Button, primary: true, children: ["Hola"]}

  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Bard.Render.DSL
    end
  end

  @doc "Create an empty tag"
  defmacro r(tag) do
    {tag, []}
  end

  @doc "Create a tag with props"
  defmacro r(tag, props)

  defmacro r(tag, props) when is_list(props) do
    {tag, kw_props(props)}
  end

  defmacro r(tag, child) do
    {tag, kw_props(do: child)}
  end

  @doc "Create a tag with props and children"
  defmacro r(tag, props, children)

  defmacro r(tag, props, children) do
    {tag, kw_props(props) ++ [children(children)]}
  end

  defp children([{:do, {:__block__, _, children}}]) do
    {:children, children}
  end
  defp children([{:do, child}]) do
    {:children, [child]}
  end
  defp children(children) when is_list(children) do
    {:children, children}
  end
  defp children(child) do
    {:children, [child]}
  end

  defp kw_props(props) do
    props
    |> Enum.map(fn
      {:do, children} -> children([do: children])
      a when is_atom(a) -> {a, true}
      x -> x
    end)
  end
end
