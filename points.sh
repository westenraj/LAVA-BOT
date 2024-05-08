#!/bin/bash

# Print information about the setup and ask for user confirmation
echo "$(tput setaf 6)════════════════════════════════════════════════════════════"
echo "$(tput setaf 6)║       Welcome to LAVA Network Magma Points Script!          ║"
echo "$(tput setaf 6)║                                                              ║"
echo "$(tput setaf 6)║     Follow us on Twitter:                                   ║"
echo "$(tput setaf 6)║     https://twitter.com/cipher_airdrop                      ║"
echo "$(tput setaf 6)║                                                              ║"
echo "$(tput setaf 6)║     Join us on Telegram:                                    ║"
echo "$(tput setaf 6)║     - https://t.me/+tFmYJSANTD81MzE1                       ║"
echo "$(tput setaf 6)╚════════════════════════════════════════════════════════════$(tput sgr0)"

read -p "Do you want to continue with the installation? (Y/N): " answer
if [[ $answer != "Y" && $answer != "y" ]]; then
    echo "Aborting installation."
    exit 1
fi

# Function to create scripts and start tmux sessions
create_scripts_and_start_tmux() {
    local output_dir="$1"
    local ethereum_rpc_url="$2"
    local axelar_rpc_url="$3"
    local starknet_rpc_url="$4"
    local near_rpc_url="$5"
    local ethereum_proxy_host="$6"
    local ethereum_proxy_port="$7"
    local ethereum_proxy_user="$8"
    local ethereum_proxy_pass="$9"
    local axelar_proxy_host="${10}"
    local axelar_proxy_port="${11}"
    local axelar_proxy_user="${12}"
    local axelar_proxy_pass="${13}"
    local starknet_proxy_host="${14}"
    local starknet_proxy_port="${15}"
    local starknet_proxy_user="${16}"
    local starknet_proxy_pass="${17}"
    local near_proxy_host="${18}"
    local near_proxy_port="${19}"
    local near_proxy_user="${20}"
    local near_proxy_pass="${21}"

    # Get the current directory
    local current_dir=$(pwd)

    # Create script files in the same directory as the output directory
    local script_dir="$current_dir/$output_dir"
    mkdir -p "$script_dir"

    # Create script files
    cat > "$script_dir/main.sh" <<EOF
#!/bin/bash

while true; do
    # Ethereum
    echo "Running Ethereum script..."
    /bin/bash /root/$output_dir/ethereum.sh "$ethereum_rpc_url" "$ethereum_proxy_host" "$ethereum_proxy_port" "$ethereum_proxy_user" "$ethereum_proxy_pass"

    # StarkNet
    echo "Running StarkNet script..."
    /bin/bash /root/$output_dir/starknet.sh "$starknet_rpc_url" "$starknet_proxy_host" "$starknet_proxy_port" "$starknet_proxy_user" "$starknet_proxy_pass"

    # Axelar
    echo "Running Axelar script..."
    /bin/bash /root/$output_dir/axelar.sh "$axelar_rpc_url" "$axelar_proxy_host" "$axelar_proxy_port" "$axelar_proxy_user" "$axelar_proxy_pass"

    # NEAR Protocol
    echo "Running NEAR Protocol script..."
    /bin/bash /root/$output_dir/near.sh "$near_rpc_url" "$near_proxy_host" "$near_proxy_port" "$near_proxy_user" "$near_proxy_pass"

    # Wait for 0.25 minutes before next iteration
    sleep   # 15 seconds = 0.25 minutes
done
EOF

    # Each service's script
    cat > "$script_dir/axelar.sh" <<EOF
#!/bin/bash

RPC_URL="\$1"

OUTPUT_DIR="$script_dir/logs"

# Proxy configuration
PROXY_HOST="\$2"
PROXY_PORT="\$3"
PROXY_USER="\$4"
PROXY_PASS="\$5"

axelar_data=\$(curl -s --proxy "socks5://\$PROXY_HOST:\$PROXY_PORT" -U "\$PROXY_USER:\$PROXY_PASS" -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","id":"Cipher","method":"status"}' "\$RPC_URL")

if [ \$? -eq 0 ]; then
    if [ ! -d "\$OUTPUT_DIR" ]; then
        mkdir "\$OUTPUT_DIR"
    fi
    
    echo "\$axelar_data" >> "\$OUTPUT_DIR/axelar.txt"
    
    echo "Axelar data fetched and saved to \$OUTPUT_DIR/axelar.txt."
else
    echo "Failed to fetch Axelar data."
fi
EOF

    # Ethereum script
    cat > "$script_dir/ethereum.sh" <<EOF
#!/bin/bash

RPC_URL="\$1"

OUTPUT_DIR="$script_dir/logs"

# Proxy configuration
PROXY_HOST="\$2"
PROXY_PORT="\$3"
PROXY_USER="\$4"
PROXY_PASS="\$5"

ethereum_data=\$(curl -s --proxy "socks5://\$PROXY_HOST:\$PROXY_PORT" -U "\$PROXY_USER:\$PROXY_PASS" -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_gasPrice","id":1}' "\$RPC_URL")

if [ \$? -eq 0 ]; then
    if [ ! -d "\$OUTPUT_DIR" ]; then
        mkdir "\$OUTPUT_DIR"
    fi
    
    echo "\$ethereum_data" >> "\$OUTPUT_DIR/ethereum.txt"
    
    echo "Ethereum data fetched and saved to \$OUTPUT_DIR/ethereum.txt."
else
    echo "Failed to fetch Ethereum data."
fi
EOF

    # StarkNet script
    cat > "$script_dir/starknet.sh" <<EOF
#!/bin/bash

RPC_URL="\$1"

OUTPUT_DIR="$script_dir/logs"

# Proxy configuration
PROXY_HOST="\$2"
PROXY_PORT="\$3"
PROXY_USER="\$4"
PROXY_PASS="\$5"

starknet_data=\$(curl -s --proxy "socks5://\$PROXY_HOST:\$PROXY_PORT" -U "\$PROXY_USER:\$PROXY_PASS" -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","id":"Cipher","method":"starknet_blockNumber"}' "\$RPC_URL")

if [ \$? -eq 0 ]; then
    if [ ! -d "\$OUTPUT_DIR" ]; then
        mkdir "\$OUTPUT_DIR"
    fi
    
    echo "\$starknet_data" >> "\$OUTPUT_DIR/starknet.txt"
    
    echo "StarkNet data fetched and saved to \$OUTPUT_DIR/starknet.txt."
else
    echo "Failed to fetch StarkNet data."
fi
EOF

    # NEAR Protocol script
    cat > "$script_dir/near.sh" <<EOF
#!/bin/bash

RPC_URL="\$1"

OUTPUT_DIR="$script_dir/logs"

# Proxy configuration
PROXY_HOST="\$2"
PROXY_PORT="\$3"
PROXY_USER="\$4"
PROXY_PASS="\$5"

near_data=\$(curl -s --proxy "socks5://\$PROXY_HOST:\$PROXY_PORT" -U "\$PROXY_USER:\$PROXY_PASS" -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"block","id":"Cipher","params":{"finality":"final"}}' "\$RPC_URL")

if [ \$? -eq 0 ]; then
    if [ ! -d "\$OUTPUT_DIR" ]; then
        mkdir "\$OUTPUT_DIR"
    fi
    
    echo "\$near_data" >> "\$OUTPUT_DIR/near.txt"
    
    echo "NEAR data fetched and saved to \$OUTPUT_DIR/near.txt."
else
    echo "Failed to fetch NEAR data."
fi
EOF

    # Set permissions for all scripts
    chmod +x "$script_dir"/*

    # Start tmux session
    tmux new-session -d -s "account_$output_dir" "cd $script_dir && /bin/bash main.sh >> main.log 2>&1"
    
    echo "Scripts created successfully in $script_dir and tmux session started."
}

# Get number of accounts from the user
read -p "How many accounts will you be farming with? " num_accounts

# Get user input for each account
for ((i = 1; i <= num_accounts; i++)); do
    read -p "Enter the Ethereum RPC URL for account $i: " ethereum_rpc_url
    read -p "Enter the Ethereum proxy host for account $i: " ethereum_proxy_host
    read -p "Enter the Ethereum proxy port for account $i: " ethereum_proxy_port
    read -p "Enter the Ethereum proxy user for account $i: " ethereum_proxy_user
    read -p "Enter the Ethereum proxy password for account $i: " ethereum_proxy_pass

    read -p "Enter the Axelar RPC URL for account $i: " axelar_rpc_url
    read -p "Enter the Axelar proxy host for account $i: " axelar_proxy_host
    read -p "Enter the Axelar proxy port for account $i: " axelar_proxy_port
    read -p "Enter the Axelar proxy user for account $i: " axelar_proxy_user
    read -p "Enter the Axelar proxy password for account $i: " axelar_proxy_pass

    read -p "Enter the StarkNet RPC URL for account $i: " starknet_rpc_url
    read -p "Enter the StarkNet proxy host for account $i: " starknet_proxy_host
    read -p "Enter the StarkNet proxy port for account $i: " starknet_proxy_port
    read -p "Enter the StarkNet proxy user for account $i: " starknet_proxy_user
    read -p "Enter the StarkNet proxy password for account $i: " starknet_proxy_pass

    read -p "Enter the NEAR Protocol RPC URL for account $i: " near_rpc_url
    read -p "Enter the NEAR Protocol proxy host for account $i: " near_proxy_host
    read -p "Enter the NEAR Protocol proxy port for account $i: " near_proxy_port
    read -p "Enter the NEAR Protocol proxy user for account $i: " near_proxy_user
    read -p "Enter the NEAR Protocol proxy password for account $i: " near_proxy_pass

    folder_name="LAVA$i"
    create_scripts_and_start_tmux "$folder_name" "$ethereum_rpc_url" "$axelar_rpc_url" "$starknet_rpc_url" \
    "$near_rpc_url" "$ethereum_proxy_host" "$ethereum_proxy_port" "$ethereum_proxy_user" "$ethereum_proxy_pass" \
    "$axelar_proxy_host" "$axelar_proxy_port" "$axelar_proxy_user" "$axelar_proxy_pass" \
    "$starknet_proxy_host" "$starknet_proxy_port" "$starknet_proxy_user" "$starknet_proxy_pass" \
    "$near_proxy_host" "$near_proxy_port" "$near_proxy_user" "$near_proxy_pass"
done

echo "All scripts created and tmux sessions started successfully."
