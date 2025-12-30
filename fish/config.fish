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
    alias vi 'nvim'


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

########## Environment variables ##########
# Set fish auto suggestion color
set fish_color_autosuggestion '#808080'

# Set default editor as neovim
set -x EDITOR nvim

# term2alpha for nvim alpha images config (use: catimg -H 30 pfp.png | term2alpha > header.lua)
set -x PATH $HOME/.term2alpha/bin $PATH

# Load secrets if present
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end


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

# Makes an alpha.nvim header from a .png image
# Usage: make-alpha-header <input_image_path> <image_height> <output_file_name>
function make-alpha-header --description 'Generate a Lua header file for alpha-nvim with configurable height'
    # Check if exactly three arguments were provided
    if test (count $argv) -ne 3
        echo "Usage: make-alpha-header <input_image_path> <image_height_int> <output_file_name>"
        echo "Example: make-alpha-header ~/my_pfp.png 45 custom_header"
        return 1
    end

    set -l input_file $argv[1]
    set -l image_height $argv[2] # New argument for the height
    set -l output_name $argv[3]
    
    # Concatenate the variable and the literal string for the output filename
    set -l output_file $output_name.lua 
    
    # Check if the input image file exists
    if not test -f "$input_file"
        echo "Error: Input image file '$input_file' not found."
        return 1
    end

    # Core Logic: Execute the pipeline with the dynamic height argument
    echo "Generating '$output_file' from '$input_file' with height $image_height..."
    catimg -H "$image_height" "$input_file" | term2alpha > "$output_file"
    
    # Check the exit status of the pipeline
    if test $status -eq 0
        echo "Success! The alpha-nvim header file has been created at '$output_file'."
    else
        echo "Error: The pipeline failed (exit status: $status). Ensure 'catimg' and 'term2alpha' are installed and accessible."
    end
end

# Starts up ssh-agent for 1-time only key prompting
function ssh-login
  ssh-agent -c | source
  ssh-add
end

# Stops the ssh-agent started by ssh-login
function ssh-logout
    if set -q SSH_AGENT_PID
        echo "Killing ssh-agent (PID $SSH_AGENT_PID)"
        kill $SSH_AGENT_PID
        set -e SSH_AGENT_PID
        set -e SSH_AUTH_SOCK
    else
        echo "No ssh-agent running in this session"
    end
end

# Toggle ssh-agent on/off (start + add key, or kill it)
function ssh-toggle
    if set -q SSH_AGENT_PID
        if ps -p $SSH_AGENT_PID | grep -q ssh-agent
            echo "Stopping ssh-agent (PID $SSH_AGENT_PID)"
            kill $SSH_AGENT_PID
        end
        set -e SSH_AGENT_PID
        set -e SSH_AUTH_SOCK
        return
    end

    echo "Starting ssh-agent"
    ssh-agent -c | source
    ssh-add
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
