LOAD_WORD = 0x01
STORE_WORD = 0x02
ADD = 0x03
SUBTRACT = 0x04
HALT = 0xff
PROGRAM_COUNTER = 0x00

def main(memory)
  register_values = [0x00, 0x00, 0x00] # [program_counter_value, register_1_value, register_2_value]

  while memory[register_values.first] != HALT
    program_counter_value = register_values.first
    instruction = memory[program_counter_value]

    case instruction
    when LOAD_WORD
      register = memory[program_counter_value + 1]
      word = memory[memory[program_counter_value + 2]] + memory[memory[program_counter_value + 2] + 1] * 256
      register_values[register] = word
      register_values[0] += 3
    when ADD
      register_values[memory[program_counter_value + 1]] = register_values[memory[program_counter_value + 1]] + register_values[memory[program_counter_value + 2]]
      register_values[0] += 3
    when SUBTRACT
      register_values[memory[program_counter_value + 1]] = register_values[memory[program_counter_value + 1]] - register_values[memory[program_counter_value + 2]]
      register_values[0] += 3
    when STORE_WORD
      word = register_values[memory[program_counter_value + 1]]
      starting_output_address = memory[program_counter_value + 2]
      memory[starting_output_address] = word % 256
      memory[starting_output_address + 1] = word / 256
      register_values[0] += 3
    end
  end
end

def test
  memory = [
    0x01, 0x01, 0x10,
    0x01, 0x02, 0x12,
    0x03, 0x01, 0x02,
    0x02, 0x01, 0x0e,
    0xff,
    0x00,
    0x00, 0x00,
    0xa1, 0x14,
    0x0c, 0x00
  ]
  main(memory)
  (memory[0x0e] + memory[0x0f] * 256) == 5293
end

puts test


