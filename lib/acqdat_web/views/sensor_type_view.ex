defmodule AcqdatWeb.SensorTypeView do
  use AcqdatWeb, :view

  def value_key_data(form) do
    case data = form.data.value_keys do
      nil -> []
      _ -> data
    end
  end
end
