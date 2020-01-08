###############################################################################
# ssh
###############################################################################
if [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" = "Darwin" ]; then
  alias spook='tab_crimson Spook;ssh spook;tab_reset_color'
  alias puzzle='tab_crimson Puzzle;ssh puzzle;tab_reset_color'
  alias apache='tab_crimson Apache;ssh apache;tab_reset_color'
  alias tuculca='tab_crimson Tuculca;ssh tuculca;tab_reset_color'
  alias barraca='tab_crimson Barraca;ssh barraca;tab_reset_color'
  alias espiral='tab_crimson Espiral;ssh espiral;tab_reset_color'
  alias rockola='tab_crimson Rockola;ssh rockola;tab_reset_color'
fi