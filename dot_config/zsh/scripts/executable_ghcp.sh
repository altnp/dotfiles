#!/bin/zsh

ghcp() {
	if [ -z "$*" ]; then
		echo "Usage: ghcp <prompt>"
		exit 1
	fi

	USER_PROMPT="$*"
	OS_INFO="$(uname -s)"
	SHELL_INFO="$SHELL"

	# Instructions as requested by the user
	SYSTEM_PROMPT="You are a command-line assistant. Generate a shell script or command for the following task.
CONTEXT: OS: $OS_INFO, Shell: $SHELL_INFO.
STRICT RULES:
1. Output ONLY native shell or pwsh commands.
2. DO NOT use Python, Node.js, or other high-level scripting languages.
3. Keep output command as simple as possible, using built in commands and standard utilities whenever possible.
4. Output command only. No preamble, no explanation, no markdown backticks.
TASK: $USER_PROMPT"

	RESPONSE=$(copilot -p "$SYSTEM_PROMPT" \
		--model gpt-5-mini \
		--silent \
		--deny-tool "shell" \
		--deny-tool "write" \
		--deny-tool "read" \
		--deny-url "*")

	echo "$RESPONSE"
}
