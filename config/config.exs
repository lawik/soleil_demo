# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

config :soleil_demo, ecto_repos: [SoleilDemo.Repo]
config :soleil_demo, SoleilDemo.BatteryLogger, sleep_time_mins: 15

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1729006937"

config :nerves, :firmware, provisioning: :nerves_hub_link

config :nerves_hub_link,
  remote_iex: true,
  host: "devices.nervescloud.com",
  configurator: NervesHubLink.Configurator.SharedSecret,
  shared_secret: [
    product_key: System.fetch_env!("NH_PRODUCT_KEY"),
    product_secret: System.fetch_env!("NH_PRODUCT_SECRET")
  ],
  health: [
    metrics: %{"battery_level" => {SoleilDemo, :battery_percentage_metric, []}}
  ]

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
