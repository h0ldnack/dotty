function z --wraps='zzz ' --wraps='sudo zzz ' --description 'alias z sudo zzz '
  sudo zzz  $argv 2> /dev/null
end
