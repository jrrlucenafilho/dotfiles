function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # Pokeget greeting
    set fish_greeting
    pokeget random --hide-name
    

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    ########## Aliases ##########
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'
    alias cls 'clear'
    alias which-venv 'echo $VIRTUAL_ENV'


    ########## Completions ##########
    # Suggest existing environments (optional)
    complete \
        --command new-env \
        --arguments '(ls ~/.virtualenvs)' \
        --description 'Name for new environment'

    # Complete env names from ~/.virtualenvs
    complete \
        --command activate-venv \
        --arguments '(ls ~/.virtualenvs)' \
        --description 'Virtual environment name'

    # Completion for remove-venv: list directories in ~/.virtualenvs
    complete -c remove-venv -a "(ls ~/.virtualenvs)" --description 'Remove virtual environment'
end

########## Sets ##########
# Set fish auto suggestion color
set fish_color_autosuggestion '#808080'

# Set default editor as neovim
set -x EDITOR nvim


########### Functions ###########
# Dolphin open function
function dopen
    dolphin . &; disown
end

# Makes new python virtual environment
# Also updates kernelspec with the new kernel
# And installs ipykernel in the venv
function new-venv
    if test (count $argv) -ne 1
        echo "Usage: new-env <env_name>"
        return 1
    end

    set env_name $argv[1]
    set env_path ~/.virtualenvs/$env_name

    echo ">>> Creating uv environment: $env_path"
    uv venv $env_path

    echo ">>> Installing ipykernel inside $env_name"
    uv pip install -q --python $env_path/bin/python ipykernel

    echo ">>> Registering Jupyter kernel: $env_name"
    $env_path/bin/python -m ipykernel install --user --name $env_name --display-name "Python ($env_name)"

    echo ""
    echo "✔ Environment created: $env_path"
    echo "✔ Kernel installed: $env_name"
end

# Activate python virtual environment
function activate-venv
    if test (count $argv) -ne 1
        echo "Usage: activate-venv <env_name>"
        return 1
    end

    set env_name $argv[1]
    set env_path ~/.virtualenvs/$env_name

    if not test -d $env_path
        echo "Error: environment '$env_name' does not exist at $env_path"
        return 1
    end

    echo ">>> Activating environment: $env_name"
    source $env_path/bin/activate.fish
end

# Removes selected cirtual environment
function remove-venv
    set -l env_name $argv[1]

    if test -z "$env_name"
        echo "Usage: remove-venv <env_name>"
        return 1
    end

    set -l env_path ~/.virtualenvs/$env_name

    if not test -d $env_path
        echo "Error: Virtualenv '$env_name' does not exist."
        return 1
    end

    # Safety check for 'neovim' environment
    if test "$env_name" = "neovim"
        echo -n "WARNING: You are trying to delete the 'neovim' environment. Are you sure? (y/N) "
        read -l confirm
        if test "$confirm" != "y"
            echo "Cancelled."
            return 1
        end
    end

    echo ">>> Removing virtualenv: $env_path"
    rm -rf $env_path

    echo ">>> Removing Jupyter kernelspec: $env_name"
    jupyter kernelspec remove -f $env_name

    echo ">>> Done."
end

# Lists existing virtual environments
function list-venvs
    set -l venv_dir ~/.virtualenvs

    if not test -d $venv_dir
        echo "No virtualenv directory found at $venv_dir"
        return 1
    end

    echo "Virtual environments:"
    ls $venv_dir
end


########## Shell Wrappers ##########
# Yazi shell wrapper
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


########## Shell Inits ##########
# Zoxide init
zoxide init fish | source
