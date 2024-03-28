#!/bin/bash

board=(1 2 3 4 5 6 7 8 9)
currentPlayer="X"
playerChooseTakenPosition=0
playWithComputer=0

computer="O"

displayBoard() {
    clear
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---+---+---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---+---+---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

switchPlayer() {
    if [ "$currentPlayer" == "X" ]; then
        currentPlayer="O"
    else
        currentPlayer="X"
    fi
}

isProperPositionTaken() {
    if [ "$input" -ge 1 ] && [ "$input" -le 9 ]; then
        return 0
    fi
    
    return 1
}

isPlayerChoosingWrongPosition() {
    if [ $playerChooseTakenPosition -eq 1 ]; then
        return 0
    fi
    
    return 1
}

isWinConditionFullfiled() {
    winConditions=("012" "345" "678" "036" "147" "258" "048" "246")

    for condition in "${winConditions[@]}"; do
        charOnBoard1="${board[${condition:0:1}]}"
        charOnBoard2="${board[${condition:1:1}]}"
        charOnBoard3="${board[${condition:2:1}]}"


        if [ "$charOnBoard1" == "$charOnBoard2" ] && [ "$charOnBoard2" == "$charOnBoard3" ]; then
            return 0
        fi
    done
    return 1
}

isDrawConditionFullfiled() {
    for cell in "${board[@]}"; do
        if [[ "$cell" =~ [0-9] ]]; then
            return 1
        fi
    done
    return 0
}

makeMove() {
    position=$1
    if [[ "${board[$position-1]}" =~ [0-9] ]]; then
        board[$position-1]=$currentPlayer
        playerChooseTakenPosition=0
        return 0
    else
        echo -e "\nGiven position is taken. Choose another one."
        sleep 2
        playerChooseTakenPosition=1
        return 1
    fi
}

displayMenu() {
    clear
    echo "=== MENU ==="
    echo "1. Play multiplyer"
    echo "2. Play with computer"
    echo "3. Continue saved game"
}

makeChoice() {
    read -p "Choose an option: " choice
    
    case $choice in
    1)
        playWithComputer=0
        ;;
    2)  
        playWithComputer=1
        ;;
    3)
        loadGame
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
}

loadGame() {
    if [ -f "saved_game.txt" ]; then
        source "saved_game.txt"
    else
        echo "No saved game."
    fi
}

saveGame() {
    echo "board=(${board[@]})" > "saved_game.txt"
    echo "currentPlayer=\"$currentPlayer\"" >> "saved_game.txt"
    echo "playerChooseTakenPosition=$playerChooseTakenPosition" >> "saved_game.txt"
    echo "playWithComputer=$playWithComputer" >> "saved_game.txt"
    echo "Game saved."
}

computerChoosePlace() {
    randomPosition=$((RANDOM % 9 + 1))
    if [[ "${board[$randomPosition-1]}" =~ [0-9] ]]; then
        input=$randomPosition
    else
        computerChoosePlace
    fi
}

isNonComputerTurn() {
    if [ $playWithComputer -eq 0 ] || ([ $playWithComputer -eq 1 ] && [ "$currentPlayer" == "X" ]); then
        return 0
    fi

    return 1
}

isGameWithComputer() {
    if [ $playWithComputer -eq 1 ]; then
        return 0
    fi

    return 1
}

gameLoop() {
    while true; do
        displayBoard

        if ! isGameWithComputer || isNonComputerTurn; then
            echo -e "\n$currentPlayer player turn, choose position 1-9 or or write \"s\" to save game"
            read input
        fi

        if [ "$input" == "s" ]; then
            saveGame
            exit 0
        fi

        if isGameWithComputer && [ "$currentPlayer" == "$computer" ]; then
            computerChoosePlace
        fi

        if isProperPositionTaken; then
            makeMove "$input"

            while isNonComputerTurn && isPlayerChoosingWrongPosition; do
                read position
                makeMove "$input"
            done

            if isWinConditionFullfiled; then
                displayBoard
                echo -e "\nPlayer $currentPlayer won!"
                break
            elif isDrawConditionFullfiled; then
                displayBoard
                echo -e "\nDraw!"
                break
            fi

            switchPlayer;
        else
            echo -e "\nWrong input. Choose number 1-9."
            sleep 2
        fi
    done
}


displayMenu
makeChoice
gameLoop
