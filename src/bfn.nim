import os
import system
import tables

var data: array[30_000, uint8]
var dataPointer: uint8 = 0

var instructions: string
var instructionPointer: int = 0

proc incrementByte() =
  inc(data[dataPointer])

proc decrementByte() =
  dec(data[dataPointer])

proc readByte() =
  var buf: array[1, byte]
  discard stdin.readBytes(buf, 0, 1)
  data[dataPointer] = buf[0]

proc outputByte() =
  stdout.write(chr(data[dataPointer]))

proc incrementDataPointer() =
  inc(dataPointer)

proc decrementDataPointer() =
  dec(dataPointer)

proc conditionalJumpForward() =
  if data[dataPointer] == 0:
    var openPairs = 1
    while openPairs != 0:
      inc(instructionPointer)
      if instructions[instructionPointer] == '[':
        inc(openPairs)
      elif instructions[instructionPointer] == ']':
        dec(openPairs)

proc conditionalJumpBackwards() =
  if data[dataPointer] != 0:
    var openPairs = 1
    while openPairs != 0:
      dec(instructionPointer)
      if instructions[instructionPointer] == ']':
        inc(openPairs)
      elif instructions[instructionPointer] == '[':
        dec(openPairs)

var instructionToProc = {
  '+': incrementByte,
  '-': decrementByte,
  '>': incrementDataPointer,
  '<': decrementDataPointer,
  '[': conditionalJumpForward,
  ']': conditionalJumpBackwards,
  ',': readByte,
  '.': outputByte,
  }.newTable

proc main() =
  instructions = paramStr(1).readFile()

  while true:
    var nextInstruction = instructions[instructionPointer]
    if instructionToProc.contains(nextInstruction):
      instructionToProc[nextInstruction]()
    inc(instructionPointer)
    if instructionPointer >= len(instructions):
      system.quit(0)

when isMainModule:
  main()
