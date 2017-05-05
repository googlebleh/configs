#!/usr/bin/python3

import os


def FlagsForFile(fpath, **kwargs):
    name, ext = os.path.splitext(fpath)
    
    if ext == '.c':
        flags = ['-x', 'c', '-std=c11', '-Wall', '-Wextra', '-Werror']
        return {'flags': flags}
    
    elif ext in {'.cpp', '.h', '.cc'}:
        flags = ['-x', 'c++', '-std=c++11', '-Wall', '-Wextra', '-Werror']
        return {'flags': flags}
