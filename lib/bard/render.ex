defmodule Bard.Render do

  @moduledoc """
  This module helps converting a node tuple
  like

     {Button, [primary: true, children: ["Hola"]]}

  into a representation suitable to be sent
  to the client side Bard library.
  """

  @doc """
  Renders a component with props.

  Invokes the component's module with the given
  props and with a brad.

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

  The rendered tree is deep-first walked.
  """
  def render({component, props}, bard) do
    ast = component.render(props, bard)
    expanded_ast = render_deep_first(ast, bard)
    if ast == expanded_ast do
      expanded_ast
    else
      render(expanded_ast, bard)
    end
  end

  defp render_deep_first({comp, props}, bard) do

  end

end
