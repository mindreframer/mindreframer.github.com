---
date: '2013-10-31'
title: The cleanest GLI Bash / ZSH Tab-Completion
tags:
- tricks
---


## The perfect solution for you GLI::App based console-tools in Bash/ZSH


### Official recommendation


    function get_todo_commands()
    {
      if [ -z $2 ] ; then
        COMPREPLY=(`todo help -c`)
      else
        COMPREPLY=(`todo help -c $2`)
      fi
    }


Problems with that solution:

  - does not work on ZSH
  - does autocompletion only for the 1st and 2nd level, stops after that
  - is not very extendable


After fiddling for 2 hours I came up with the simplest and always working solution:

    ## this enables bash completion in ZSH
    if [[ -n ${ZSH_VERSION-} ]]; then
      autoload -U +X bashcompinit && bashcompinit
    fi

    ## instruct, where the completions for my-cli come from
    complete -F get_my_cli_commands my-cli

    function get_my_cli_commands()
    {
      ## we have following variables available:
      # - COMP_WORDS: array with arguments, that starts with  "my-cli"
      # - COMP_CWORD: the index of the current "tab-completed" word

      local binary="my-cli"

      # args-array starting by index:1
      help_params=${COMP_WORDS[@]:1}

      # remove flags/options, so we have only "verbs"
      clean_params=${help_params//-*([^ ])?( )}
      COMPREPLY=(`$binary help -c $clean_params`)
    }
