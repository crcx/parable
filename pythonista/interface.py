#!/usr/bin/env python

import os
import sys
from parable import *
from scene import *


current_x = 0
current_y = 0

def opcodes(slice, offset, opcode):
    global MAX_SLICE, p_slices, p_map
    global dictionary_names, dictionary_slices
    global types, stack
    global current_x, current_y
    global TYPE_NUMBER
    if opcode == 2000:
        stack_push(current_x, TYPE_NUMBER)
        stack_push(current_y, TYPE_NUMBER)
    if opcode == 2001:
        b = stack_pop()
        g = stack_pop()
        r = stack_pop()
        fill(r, g, b)
    if opcode == 2002:
        h = stack_pop()
        w = stack_pop()
        y = stack_pop()
        x = stack_pop()
        ellipse(x, y, w, h)
    if opcode == 2003:
        b = stack_pop()
        g = stack_pop()
        r = stack_pop()
        background(r, g, b)
    return offset



m = 0
class MyScene (Scene):
    def setup(self):
        prepare_slices()
        prepare_dictionary()
        parse_bootstrap(open('bootstrap.p').readlines())
        parse_bootstrap(open('sketch.p').readlines())

    def draw(self):
        global m
        if m == 0:
            m = 1
            interpret(lookup_pointer('draw'), opcodes)
            m = 0
        else:
            pass

    def touch_began(self, touch):
        global current_x, current_y
        current_x = touch.location.x
        current_y = touch.location.y

    def touch_moved(self, touch):
        global current_x, current_y
        current_x = touch.location.x
        current_y = touch.location.y

    def touch_ended(self, touch):
        global current_x, current_y
        current_x = 0
        current_y = 0


run(MyScene())
