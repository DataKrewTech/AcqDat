defmodule Acqdat.Support.Factory do
  use ExMachina.Ecto, repo: Acqdat.Repo

  alias Acqdat.Schema.{
    User,
    Device,
    SensorType
  }

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
      visualizer: "pie-chart"
    }
  end

end
