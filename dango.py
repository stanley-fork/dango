#!/usr/bin/env python3
# from goban import Board
# from groups import *
from game import *
# from nigiri import nigiri


def game_round(board, move, black, white):
    board.display()
    print(f' Black captures: {board.black_captures}')
    print(f' White captures: {board.white_captures}')
    black.turn(board, move)
    clear()
    board.display()
    print(f' Black captures: {board.black_captures}')
    print(f' White captures: {board.white_captures}')
    white.turn(board, move)
    clear()


def play():
    board, move, black, white = game_setup()
    # while game_not_over(move):
    while True:
        try:
            game_round(board, move, black, white)
        except:
            input('Please try again. Press enter to continue')
            clear()
    input('Thank you for the game')
    clear()


if __name__ == "__main__":
    play()
