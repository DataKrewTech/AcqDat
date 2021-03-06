defmodule Acqdat.Support.Factory do
  use ExMachina.Ecto, repo: Acqdat.Repo
  use Acqdat.Schema

  alias Acqdat.Schema.{
    User,
    Device,
    SensorType,
    Sensor,
    SensorNotifications,
  }

  alias Acqdat.Schema.ToolManagement.{
    Employee,
    ToolType,
    ToolBox,
    Tool,
    ToolIssue,
    ToolReturn
  }

  def user_factory() do
    %User{
      first_name: "Tony",
      last_name: "Stark",
      email: "tony@starkindustries.com",
      password_hash: "NOTASECRET"
    }
  end

  def set_password(user, password) do
    user
    |> User.changeset(%{password: password, password_confirmation: password})
    |> Ecto.Changeset.apply_changes()
  end

  def device_factory() do
    %Device{
      uuid: UUID.uuid1(:hex),
      name: sequence(:device_name, &"device#{&1}"),
      access_token: "abcd1234",
      description: "new user device"
    }
  end

  def sensor_type_factory() do
    %SensorType{
      name: sequence(:sensor_type_name, &"Sensor#{&1}"),
      make: "From Adafruit",
      identifier: sequence(:type_identifier, &"identifier#{&1}"),
      visualizer: "pie-chart",
      value_keys: ["temp", "humid"]
    }
  end

  def sensor_factory() do
    %Sensor{
      uuid: UUID.uuid1(:hex),
      name: sequence(:sensor_name, &"Sensor#{&1}"),
      device: build(:device),
      sensor_type: build(:sensor_type)
    }
  end

  def sensor_notification_factory() do
    %SensorNotifications{
      alarm_status: true,
      sensor: build(:sensor),
      rule_values: %{
        "temp" => %{
          "module" => 0,
          "preferences" => %{"lower_limit" => "10.0", "upper_limit" => "20"}
        }
      }
    }
  end

  def employee_factory() do
    %Employee{
      name: sequence(:employee_name, &"Employee#{&1}"),
      phone_number: "123456",
      address: "54 Peach Street, Gotham",
      role: "worker",
      uuid: "U" <> permalink(4),
      card_uuid: "U" <> permalink(4)
    }
  end

  def tool_type_factory() do
    %ToolType{
      identifier: sequence(:tl_type_identifier, &"ToolType#{&1}")
    }
  end

  def tool_box_factory() do
    %ToolBox{
      name: sequence(:employee_name, &"ToolBox#{&1}"),
      uuid: "TB" <> permalink(4),
      description: "Tool box at Djaya"
    }
  end

  def tool_factory() do
    %Tool{
      name: sequence(:employee_name, &"Tool#{&1}"),
      uuid: "T" <> permalink(4),
      status: "in_inventory",
      tool_box: build(:tool_box),
      tool_type: build(:tool_type),
      card_uuid: "T" <> permalink(4)
    }
  end

  def employee_list(%{employee_count: count}) do
    employees = insert_list(count, :employee)
    [employees: employees]
  end

  def tool_list(%{tool_count: count, tool_box: tool_box}) do
    tools = insert_list(count, :tool, tool_box: tool_box)
    [tools: tools]
  end

  def tool_issue_factory() do
    %ToolIssue{
      employee: build(:employee),
      tool: build(:tool),
      tool_box: build(:tool_box),

      issue_time: DateTime.truncate(DateTime.utc_now(), :second)
    }
  end

  def tool_return(tool_issue) do
    return_params = %{
      employee_id: tool_issue.employee_id,
      tool_id: tool_issue.tool.id,
      tool_box_id: tool_issue.tool_box.id,
      tool_issue_id: tool_issue.id,

      return_time: DateTime.truncate(DateTime.utc_now(), :second)
    }
    changeset = ToolReturn.changeset(%ToolReturn{}, return_params)
    Repo.insert(changeset)
  end

end
