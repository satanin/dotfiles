if [ "$(uname)" = "Linux" ] && ! which babushka > /dev/null 2>&1; then
  ###############################################################################
  # vagrant environment aliases
  ###############################################################################
  alias b='babushka'
  alias payup='babushka pt:payschool.up'
  alias coreup='babushka pt:core.up'
  alias operup='babushka pt:operations.up'
  alias dashrup='babushka pt:dashboards.up'
fi