defmodule Bard.Render do

  @moduledoc """
  This module helps converting a tuple
  like

     {Button, [primary: true, children: ["Hola"]]}

  into a representation suitable to be sent
  to the client side Bard library.
  """

  @doc """
  Renders a component with props.

  Invokes the component's module with the given
  props and with a bard struct.

  The props received by the `render/2` function
  are Maps instead of Keywords as produced by
  Bard.Render.DSL. That's because the client
  side Bard library will send a javascript props
  object, and many of its keys may not exist as
  atoms on the erlang node. Thus we avoid enforcing
  the usage of Keyword, and prefer instead to use
  maps with string keys.

  Because of this, when the module's `render/2`
  function returns, its properties are converted
  into a map of string keys to keep with the
  initial form, even if you used the DSL to create
  the rendered tree.

  Just like on macro expansion, the result is
  automatically recursed until no more possible
  renderable components can be found.

  The rendered tree is depth-first walked.
  """
  def render(module_and_props, bard)
  def render(cmp, bard), do: render(cmp, bard, &(&1))

  @doc false
  def render({component, props}, bard, into) do
    component.render(props, bard) |> normalize(bard, into)
  end

  defp normalize({component, props}, bard, into) when is_list(props) do
    if is_tag(component) do
      {component, normalize_children(props, bard, into) |> normalize_props(bard, into)}
      |> expand(bard, into)
      |> into.()
    else
      {to_string(component), normalize(props, bard, into)}
    end
  end

  defp normalize(lst, bard, into) when is_list(lst) do
    Enum.map(lst, &normalize(&1, bard, into))
  end

  defp normalize(x, _bard, _into), do: x

  defp normalize_children(props, bard, into) when is_list(props) do
    update_in(props, [:children], fn
      nil -> []
      children -> Enum.map(children, &normalize(&1, bard, into))
    end)
  end

  defp normalize_props(props, bard, into) when is_list(props) do
    Enum.map(props, fn
      {:on, handlers} -> {"on", def_handlers_ref(handlers, bard)}
      {:children, children} -> {"children", children}
      {k, v} when is_atom(k) -> {to_string(k), normalize(v, bard, into)}
    end)
    |> Enum.into(%{})
  end

  defp def_handlers_ref(handlers, bard) do
    handlers
    |> Enum.map(fn {event, handler} ->
      ref = Bard.defun(bard, handler)
      %{to_string(event) => %{"fun" => ref}}
    end)
  end

  defp is_tag(component) when is_atom(component) do
    to_string(component) == Macro.camelize(to_string(component))
  end
  defp is_tag(_), do: false

  defp expand({component, props}, bard, into) when is_atom(component) do
    if function_exported?(component, :render, 2) do
      render({component, props}, bard, into)
    else
      {component, props}
    end
  end

  @doc false
  def into_map({component, props}) do
    %{"component" => component, "props" => props}
  end

end
