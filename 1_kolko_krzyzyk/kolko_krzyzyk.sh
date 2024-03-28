#!/bin/bash

board=(1 2 3 4 5 6 7 8 9)
currentPlayer="X"
playerChooseTakenPosition=0

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
    if [ "$position" -ge 1 ] && [ "$position" -le 9 ]; then
        return 0
    fi
    
    return 1
}

isPlayerChoosingWrongPosition() {
    if [ $playerChooseTakenPosition -eq 1 ]; then
        return
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

while true; do
    displayBoard

    echo -e "\n$currentPlayer player turn, choose position 1-9: "
    read position

    if isProperPositionTaken; then
        makeMove "$position"

        while isPlayerChoosingWrongPosition; do
            read position
            makeMove "$position"
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
