# Define a constant to store application values
#
#   CONFIG[Rails.env]['key'] # value of key in current environment
#   CONFIG['key'] # value of environment agnostic key

CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")
