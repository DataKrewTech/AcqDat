defmodule Acqdat.Repo.Migrations.AddCardUuids do
  use Ecto.Migration

  def change do
    alter table("acqdat_tm_employees") do
      add(:card_uuid, :string, null: false)
    end

    alter table("acqdat_tm_tools") do
      add(:card_uuid, :string, null: false)
    end

    create unique_index("acqdat_tm_employees", [:card_uuid])
    create unique_index("acqdat_tm_tools", [:card_uuid])

  end

end
