defmodule Acqdat.Schema do
  @moduledoc """
  Interface for DB related rules.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      alias Acqdat.Repo
    end
  end
end
