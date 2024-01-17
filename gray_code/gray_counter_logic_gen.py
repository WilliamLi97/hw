from sympy.logic import SOPform
from sympy import symbols
import argparse

parser = argparse.ArgumentParser("gray_counter_logic_gen.py")
parser.add_argument("bits", help="number of bits")
args = parser.parse_args()

NUM_BITS = int(args.bits)

def gen_gray_bits(num_bits: int) -> list:
    gray_10 = [i ^ (i >> 1) for i in range(0, pow(2, num_bits))]
    return [bits(num, num_bits) for num in gray_10]

def bits(number, num_bits):
    return [1 & (number >> bit_position) for bit_position in range(0, num_bits)]

def gen_logic(current_states, next_states):
    current_symbols = symbols(f"q[:{NUM_BITS}]")
    next_symbols = symbols(f"q_next[:{NUM_BITS}]")
    minterms_list = [[] for _ in range(0, NUM_BITS)]

    for bit_index in range(0, NUM_BITS):
        for next_index, next_state in enumerate(next_states):
            if next_state[bit_index]:
                minterms_list[bit_index].append(current_states[next_index])

    for i in range(len(next_symbols)-1, -1, -1):
        expression = SOPform(current_symbols, minterms_list[i])
        print(f"assign {next_symbols[i]} = {expression};".replace("~q", "q_n"))
        
gray_bits = gen_gray_bits(NUM_BITS)
current_states = gray_bits
next_states = gray_bits[1:] + gray_bits[:1]

gen_logic(current_states, next_states)
