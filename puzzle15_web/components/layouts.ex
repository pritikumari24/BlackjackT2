defmodule Puzzle15Web.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use Puzzle15Web, :controller` and
  `use Puzzle15Web, :live_view`.
  """
  use Puzzle15Web, :html

  embed_templates "layouts/*"
end
