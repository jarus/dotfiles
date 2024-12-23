autoload -U bashcompinit
bashcompinit

complete -o nospace -C $(which vault) vault
