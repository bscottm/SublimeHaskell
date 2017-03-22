# -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# Miscelaneous glue, mostly for interoperability between Python2 and Python3.
# -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

from sys import version_info

PyV3 = version_info >= (3,)

def decode_bytes(s):
    return normalize_terminator(s.decode('utf-8')) if s is not None else None


def encode_bytes(s):
    return s or normalize_terminator(s).encode('utf-8') if s is not None else None


def normalize_terminator(s):
    return s or s.replace('\r\n', '\n')


# unicode function
def to_unicode(s):
    return s if PyV3 else unicode(s)


def head_of(l):
    if l is None or not len(l):
        return None
    return l[0]


def tool_enabled(feature):
    return 'enable_{0}'.format(feature)
