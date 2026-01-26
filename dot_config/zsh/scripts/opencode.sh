opencode-wrapper() {
    emulate -L zsh
    local -a original_args=("$@")
    local -a passthrough=()
    local worktree_name=""
    local model=""
    local multi_model=0
    local attempts=""
    while (($# > 0)); do
        case "$1" in
            --wt)
                if (($# < 2)); then
                    print -u2 -- "--wt requires a value"
                    return 1
                fi
                worktree_name="$2"
                shift 2
                ;;
            --wt=*)
                worktree_name="${1#--wt=}"
                shift
                ;;
            --model)
                if (($# < 2)); then
                    print -u2 -- "--model requires a value"
                    return 1
                fi
                model="$2"
                shift 2
                ;;
            --model=*)
                model="${1#--model=}"
                shift
                ;;
            --multi-model)
                multi_model=1
                if [[ -n "$2" && "$2" != -* ]]; then
                    attempts="$2"
                    shift 2
                else
                    shift
                fi
                ;;
            --)
                shift
                passthrough+=("$@")
                break
                ;;
            *)
                passthrough+=("$1")
                shift
                ;;
        esac
    done
    local git_root=""
    local repo_name=""
    git_root=$(__oc_git_root)
    if [[ -n "$git_root" ]]; then
        repo_name=$(__oc_repo_name "$git_root")
    fi
    if ((multi_model == 1)); then
        if [[ -z "$TMUX" ]]; then
            print -u2 -- "--multi-model requires an attached tmux session."
            return 1
        fi
        if [[ -z "$git_root" ]]; then
            print -u2 "Not a git repo; --multi-model requires a git repo."
            return 1
        fi
        local base_name=""
        while [[ -z "$base_name" ]]; do
            read -r "base_name?Worktree base name: "
        done
        local -a all_models=(codex opus sonnet gemini-flash)
        if [[ -z "$attempts" ]]; then
            while true; do
                read -r "attempts?Attempts per model: "
                if [[ "$attempts" =~ '^[0-9]+$' ]] && ((attempts > 0)); then
                    break
                fi
                print -u2 "Enter a positive number."
            done
        elif [[ ! "$attempts" =~ '^[0-9]+$' ]] || ((attempts <= 0)); then
            print -u2 -- "--multi-model requires a positive attempts count"
            return 1
        fi
        local -a selected_models=()
        local selection
        local i=1
        while ((i <= attempts)); do
            print -r -- "Select model ${i}:"
            select selection in "${all_models[@]}"; do
                if [[ -n "$selection" ]]; then
                    break
                fi
                print -u2 "Choose a valid model number."
            done
            selection=$(__oc_model_label "$selection") || {
                print -u2 "Unknown model: $selection"
                return 1
            }
            selected_models+=("$selection")
            ((i++))
        done
        local initial_prompt
        read -r "initial_prompt?Prompt: "
        typeset -A model_counts
        typeset -A model_index
        local selected_model
        for selected_model in "${selected_models[@]}"; do
            model_counts[$selected_model]=$((${model_counts[$selected_model]:-0} + 1))
        done
        local first_window=1
        local first_wt_name=""
        local first_wt_path=""
        local -a first_run_args=()
        for selected_model in "${selected_models[@]}"; do
            model_index[$selected_model]=$((${model_index[$selected_model]:-0} + 1))
            local suffix="${selected_model}"
            if ((model_counts[$selected_model] > 1)); then
                suffix+="-${model_index[$selected_model]}"
            fi
            local wt_name="${base_name}-${suffix}"
            local wt_path
            wt_path=$(__oc_create_worktree "$git_root" "$repo_name" "$wt_name") || return 1
            local mapped_model
            mapped_model=$(__oc_map_model "$selected_model") || {
                print -u2 "Unknown model: $selected_model"
                return 1
            }
            local -a run_args=("--port" "0" "--model" "$mapped_model" "${passthrough[@]}")
            if [[ -n "$initial_prompt" ]]; then
                run_args+=("--prompt" "$initial_prompt")
            fi
            if ((first_window == 1)); then
                first_window=0
                first_wt_name="$wt_name"
                first_wt_path="$wt_path"
                first_run_args=("${run_args[@]}")
            else
                tmux new-window -d -n "$wt_name" -c "$wt_path" zsh -c 'opencode "$@"; exec zsh' -- "${run_args[@]}" || return 1
            fi
        done
        if [[ -z "$first_wt_path" ]]; then
            print -u2 "No model sessions created."
            return 1
        fi
        cd "$first_wt_path" || return 1
        tmux rename-window "$first_wt_name" >/dev/null 2>&1
        command opencode "${first_run_args[@]}"
        return 0
    fi
    if [[ -n "$worktree_name" ]]; then
        if [[ -z "$git_root" ]]; then
            print -u2 -- "--wt requires a git repo."
            return 1
        fi
        local wt_path
        wt_path=$(__oc_worktree_for_branch "$git_root" "$worktree_name")
        if [[ -n "$wt_path" ]]; then
            cd "$wt_path" || return 1
        else
            wt_path=$(__oc_create_worktree "$git_root" "$repo_name" "$worktree_name") || return 1
            cd "$wt_path" || return 1
        fi
        if [[ -n "$TMUX" ]]; then
            tmux rename-window "$worktree_name" >/dev/null 2>&1
        fi
    fi
    local -a run_args=("--port" "0" "${passthrough[@]}")
    if [[ -n "$model" ]]; then
        local mapped
        mapped=$(__oc_map_model "$model") || {
            print -u2 "Unknown model: $model"
            return 1
        }
        run_args+=("--model" "$mapped")
    fi
    command opencode "${run_args[@]}"
}

__oc_git_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

__oc_map_model() {
    case "$1" in
        codex) print -r -- "openai/gpt-5.2-codex" ;;
        opus) print -r -- "github-copilot/claude-opus-4.5" ;;
        sonnet) print -r -- "github-copilot/claude-sonnet-4.5" ;;
        gemini-flash) print -r -- "github-copilot/gemini-3-flash-preview" ;;
        openai/gpt-5.2-codex | github-copilot/claude-opus-4.5 | github-copilot/claude-sonnet-4.5 | github-copilot/gemini-3-flash-preview) print -r -- "$1" ;;
        *) return 1 ;;
    esac
}

__oc_repo_name() {
    local git_root="$1"
    local origin_url
    origin_url=$(git -C "$git_root" remote get-url origin 2>/dev/null)
    if [[ -n "$origin_url" ]]; then
        local repo_name="${origin_url:t}"
        print -r -- "${repo_name%.git}"
        return 0
    fi
    print -r -- "${git_root:t}"
}

__oc_model_label () {
        case "$1" in
                (codex | openai/gpt-5.2-codex) print -r -- "codex" ;;
                (opus | github-copilot/claude-opus-4.5) print -r -- "opus" ;;
                (sonnet | github-copilot/claude-sonnet-4.5) print -r -- "sonnet" ;;
                (gemini-flash | github-copilot/gemini-3-flash-preview) print -r -- "gemini-flash" ;;
                (*) return 1 ;;
        esac
}

__oc_create_worktree () {
        local git_root="$1"
        local repo_name="$2"
        local worktree_name="$3"
        local agents_dir="$HOME/repos/.agents"
        local base_dir="$agents_dir/$repo_name"
        local sanitized_name="$worktree_name"
        if [[ "$sanitized_name" != ${repo_name}:* ]]
        then
                sanitized_name="$repo_name:$sanitized_name"
        fi
        local worktree_path="$base_dir/$sanitized_name"
        mkdir -p "$agents_dir" || return 1
        mkdir -p "$base_dir" || return 1
        if [[ -d "$worktree_path" ]]
        then
                print -r -- "$worktree_path"
                return 0
        fi
        if git -C "$git_root" show-ref --verify --quiet "refs/heads/$worktree_name"
        then
                git -C "$git_root" worktree add -q "$worktree_path" "$worktree_name" > /dev/null 2>&1 || return 1
        else
                git -C "$git_root" worktree add -q -b "$worktree_name" "$worktree_path" > /dev/null 2>&1 || return 1
        fi
        print -r -- "$worktree_path"
}

__oc_worktree_for_branch () {
        local git_root="$1"
        local branch_name="$2"
        local current_path=""
        local line
        for line in "${(@f)$(git -C "$git_root" worktree list --porcelain)}"
        do
                if [[ "$line" == worktree\ * ]]
                then
                        current_path="${line#worktree }"
                        continue
                fi
                if [[ -n "$current_path" && "$line" == "branch refs/heads/$branch_name" ]]
                then
                        print -r -- "$current_path"
                        return 0
                fi
        done
        return 1
}

alias oc="opencode-wrapper"
