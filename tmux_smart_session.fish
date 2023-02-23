#! /bin/fish

function get_z_result
    set select_result (zoxide query -l | peco --prompt "switch to session:")
    #if empty exit
    if test -z $select_result
        exit 0
    end
    echo $select_result
end

function try_to_get_in_session_list
    if test -z $argv
        return
    end
    set session_name $argv
    echo (tmux list-sessions | grep $session_name | awk '{print $1}')
end

function display
    if test -z $argv
        return
    end
    if test -z $TMUX
        echo $argv
    else
        tmux display $argv
    end
end

function get_session_name
    #echo (basename $argv)
    echo (pathshorten (string replace "." "•"  $argv) 3)
end

function t_not_active
    echo tmux is not active

    set file_path $argv
    set session_name (get_session_name $file_path)
    #look for session
    if test -z $(try_to_get_in_session_list $session_name)
        # session does not exist
        display "creating session: $session_name"
        # jump to directory
        cd $file_path
        # create session
        tmux new-session -s $session_name
    else
        # session exists
        display "attach to exist session: $session_name"
        # attach to session
        tmux attach -t $session_name
    end
end

function t_active 
        set file_path $argv
        set session_name (get_session_name $file_path)

        if test -z (try_to_get_in_session_list $session_name)
            display "Creating and swith to session: $session_name"
            cd $file_path
            # create session -d for default size -s for name
            tmux new-session -d -s $session_name
            # attach to session
            tmux switch-client -t $session_name
        else
            display "Switch to exists session: $session_name"
            # switch to tmux session
            tmux switch-client -t $session_name
        end
end

function tmux_smart_session -d "switch to session, -i/--init indicate the initial file path"


    # handle argument
    argparse i/init -- $argv
    or return
    echo $argv
    # if -init | -i parameter is exist and not active pane in current client
    if set -ql _flag_init
        set init_path $argv[1]
        # if no server running, there will be a error, result will be empty
        if test -z (tmux list-sessions | head -1)
            # initialize tmux with path parameter
            if test -n $init_path
                t_not_active $init_path
            else
                # if no path parameter, use home directory
                t_not_active $HOME
            end
        else 
            # Attach to the most recently used session
            tmux attach-session
        end
        return

    else 
        set file_path (get_z_result)

        if test -z $TMUX
            t_not_active $file_path
        else
            t_active $file_path
        end
    end
end
