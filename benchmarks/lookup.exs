Benchee.run(
  %{
    "simple_lookup" => fn -> Tzdata.zone_exists?("Etc/UTC") end
  }
)
