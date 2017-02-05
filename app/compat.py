# GS Squirrel compatibility layer

import hashlib

def SHA1(_str):
    sha_1 = hashlib.sha1()
    sha_1.update(_str.encode())
    return sha_1.hexdigest()