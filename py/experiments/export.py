# Copyright (c) 2013  Charles Childers
#

import json
from parable import *

def export_parable_state(type):
    """export a parable session to the specified format"""
    global stack, types, dictionary_names, dictionary_slices, p_map, p_slices
    if type == 'json':
        return json.dumps({"stack": stack, "types": types, "dictionary_names": dictionary_names, "dictionry_slices": dictionary_slices, "p_map": p_map, "p_slices": p_slices})
    else:
        return 'unknown export format'
