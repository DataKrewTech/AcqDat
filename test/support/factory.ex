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

  alias Acqdat.Schema.ToolManagement.{Employee, ToolType}

  def user_factory() do
    %User{
      first_name: "Tony",
      last_name: "Stark",
      email: "tony@starkindustries.com",
      password_hash: ""
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
      role: "big boss",
      uuid: "U" <> permalink(4)
    }
  end

  def tool_type_factory() do
    %ToolType{
      identifier: sequence(:tl_type_identifier, &"ToolType#{&1}")
    }
  end

end
