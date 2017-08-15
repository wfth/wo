defmodule WoWeb do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use WoWeb, :controller
      use WoWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: WoWeb

      alias Wo.Repo
      import Ecto
      import Ecto.Query

      import WoWeb.Router.Helpers
      import WoWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/wo_web/templates",
                        namespace: WoWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import WoWeb.Router.Helpers
      import WoWeb.ErrorHelpers
      import WoWeb.Gettext
      import WoWeb.TemplateHelpers
      import WoWeb.Session, only: [logged_in_user_type: 1]
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
