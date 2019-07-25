defmodule Acqdat.Repo.Migrations.AddToolIssueReturnTables do
  use Ecto.Migration

  def change do
    create table("acqdat_tm_tool_issue") do
      add(:issue_time, :utc_datetime, null: false)

      #associations
      add(:employee_id, references("acqdat_tm_employees", on_delete: :restrict), null: false)
      add(:tool_box_id, references("acqdat_tm_tool_boxes", on_delete: :restrict), null: false)
      add(:tool_id, references("acqdat_tm_tools", on_delete: :restrict), null: false)

      timestamps()
    end


    create table("acqdat_tm_tool_return") do
      add(:return_time, :utc_datetime, null: false)

      #associations
      add(:employee_id, references("acqdat_tm_employees", on_delete: :restrict), null: false)
      add(:tool_box_id, references("acqdat_tm_tool_boxes", on_delete: :restrict), null: false)
      add(:tool_id, references("acqdat_tm_tools", on_delete: :restrict), null: false)
      add(:tool_issue_id, references("acqdat_tm_tool_issue", on_delete: :restrict), null: false)

      timestamps()
    end

    create unique_index("acqdat_tm_tool_return", [:tool_issue_id], name: :unique_issue_for_return)

  end
end
