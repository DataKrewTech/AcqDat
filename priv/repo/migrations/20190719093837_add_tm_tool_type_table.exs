defmodule Acqdat.Repo.Migrations.AddTmToolTypeTable do
  use Ecto.Migration

  def change do
    create table("acqdat_tm_tool_types") do
      add(:identifier, :citext)

      timestamps()
    end

    create unique_index("acqdat_tm_tool_types", [:identifier])
  end
end
