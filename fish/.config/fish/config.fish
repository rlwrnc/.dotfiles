function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.

    # The argument specifies the initial mode (insert, "default" or visual).
    set -g fish_key_bindings fish_vi_key_bindings
end

if status is-interactive
    fish_user_key_bindings
    bind -M insert \ef 'workspaces.fish; commandline -f repaint'
    bind --preset -M insert \cF accept-autosuggestion

    
end
