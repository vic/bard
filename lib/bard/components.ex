defmodule Bard.Components do

  defmacro __using__(_) do
    quote do
      @before_compile {Bard.Components, :__handle_render__}
    end
  end

  import Bard.Send

  def render(comp, bard) do
    bard.module.component(comp, bard)
    |> encode(bard)
    |> send_next(bard)
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

  defmacro __handle_render__(_env) do
    quote do

      def start("render:" <> _, %{"component" => component, "props" => props}, bard) do
        Bard.Components.render({String.to_existing_atom(component), props}, bard)
        bard
      end

      def stop("render:" <> _, bard) do
        bard
      end

    end
  end

end
