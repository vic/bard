defmodule Bard.Render do
  defmacro __using__(_) do
    quote do
      import Bard.Render.DSL
    end
  end

  def render({module, props}, bard) do
    props |> module.render(bard) |> encode(bard)
  end

  defp encode({tag, props}, bard) when is_atom(tag) and is_map(props) do
    %{"component" => tag, "props" => encode(props, bard)}
  end

  defp encode(map, bard) when is_map(map) do
    Enum.map(map, fn {k, v} -> {encode(k, bard), encode(v, bard)} end) |> Enum.into(%{})
  end

  defp encode(list, bard) when is_list(list) do
    Enum.map(list, &encode(&1, bard))
  end

  defp encode(value, bard), do: value

end

defmodule Bard.Render.Quoted do
  def render_tag(tag, props, children) do
    quote do
      import Bard.Render.Quoted
      {unquote(tag), with_children(kw_as_map(unquote(props)), unquote(children))}
    end
  end

  def with_children(map, []) do
    map
  end

  def with_children(map, children) do
    Map.put(map, "children", children)
  end

  def as_list({:__block__, _, children}) do
    children
  end

  def as_list(child) do
    [child]
  end

  def kw_as_map(kw) when is_list(kw) or is_map(kw) do
    if Keyword.keyword?(kw) or is_map(kw) do
      Enum.map(kw, fn {k, v} -> {to_string(k), kw_as_map(v)} end) |> Enum.into(%{})
    else
      Enum.map(kw, &kw_as_map/1)
    end
  end

  def kw_as_map(x), do: x
end

defmodule Bard.Render.DSL do
  import Bard.Render.Quoted

  defmacro r(tag, props, [do: children]) do
    render_tag(tag, props, as_list(children))
  end
  defmacro r(tag, props, children) when is_list(children) do
    render_tag(tag, props, children)
  end
  defmacro r(tag, props, child) do
    render_tag(tag, props, [child])
  end
  defmacro r(tag, [do: children]) do
    render_tag(tag, [], as_list(children))
  end
  defmacro r(tag, props = {:%{}, _, _}) do
    render_tag(tag, props, [])
  end
  defmacro r(tag, props) when is_list(props) do
    if Keyword.keyword?(props) do
      render_tag(tag, props, [])
    else
      render_tag(tag, [], props)
    end
  end
  defmacro r(tag, child) do
    render_tag(tag, [], [child])
  end
  defmacro r(tag) do
    render_tag(tag, [], [])
  end
end
