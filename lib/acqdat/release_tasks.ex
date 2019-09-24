defmodule Acqdat.ReleaseTasks do
  def seed do
    :ok = Application.load(:acqdat)

    [:postgrex, :ecto, :logger, :ecto_sql]
    |> Enum.each(&Application.ensure_all_started/1)

    Acqdat.Repo.start_link

    path = Application.app_dir(:acqdat, "priv/repo/seeds.exs")

    if File.regular?(path) do
      Code.require_file(path)
    end

    :init.stop()
  end
end
