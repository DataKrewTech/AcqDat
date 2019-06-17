defmodule AcqdatWeb.NotificationView do
  use AcqdatWeb, :view
  alias  Acqdat.Notification.PolicyMap

  def render("policy_preferences.html", params) do
    %{preferences: preferences, key: key, module: module} = params
    rules = preferences.rule_data

    form = Map.get(params, :form)

    content_tag(:div) do
      {:safe, preferences.name}

      [
        tag(:input,
          type: "hidden",
          value: module,
          name: "notification[rule_values][#{key}][module]"
        ),
        for rule <- rules do
          [
            content_tag(:label, rule.key, for: "#{key}-#{rule.key}"),
            tag(rule.type,
              name: "notification[rule_values][#{key}][preferences][#{rule.key}]",
              id: "#{key}-#{rule.key}",
              class: "form-control",
              value: rule.value
            ),
            add_errors(form, rule, key)
          ]
        end
      ]
    end
  end

  def selected(key, rule_values) do
    result = if Map.has_key?(rule_values, key) do
      "selected"
    else
      ""
    end
    result
  end

  def policy_preferences(form, key) do
    manifest = preferences_manifest(form.source, form.source.changes)
    with module_id when not is_nil(module_id) <- manifest.rule_values[key]["module"] do
      {:ok, module} = PolicyMap.load(module_id)
      preferences = module.rule_preferences(manifest.rule_values[key]["preferences"])
      params = %{preferences: preferences, key: key, module: to_string(module), form: form}
      render("policy_preferences.html", params)
    else
      nil ->
        nil
    end
  end

  defp preferences_manifest(source, changes) when changes == %{} do
    source.data
  end
  defp preferences_manifest(_source, changes) do
    changes
  end

  defp add_errors(nil, _, _), do: []
  defp add_errors(form, rule, value_key) do
    case form.errors[:rule_values] do
      nil ->
        []
      {errors, _} ->
        error = Jason.decode!(errors)
        result_list = error[value_key][to_string(rule.key)]
        append_tag(result_list)
    end
  end

  defp append_tag(nil), do: []
  defp append_tag(list), do: content_tag(:p, List.to_string(list), class: "text-danger")
end
