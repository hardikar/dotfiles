import os
import glob
import ycm_core


flags = [
"-g", # Generate debug information
"-O0", # No optimization for fast builds + good debug
"-Wall", # Essential
"-Wextra", # Essential
"-Wswitch-enum", # Warn when switch is missing a case on enum
"-Wunreachable-code", # Warn on unreachable code
"-Wshadow", # Warn if a local variable shadows a global variable
"-Wfloat-equal", # Warn if testing equality of floats
]

extra_includes = [
"-I/opt/gp_xerces/include",
]
cpp_includes = [
#"-I/usr/include/c++/4.2.1",
]

def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return list( flags )
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    new_flag = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        new_flag = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        new_flag = path_flag + os.path.join( working_directory, path )
        break

    if new_flag:
      new_flags.append( new_flag )
  return new_flags


def FlagsForFile( filename, **kwargs ):
  global flags

  if extra_includes:
    flags += extra_includes

  try:
    data = kwargs['client_data']
    filetype = data['&filetype']

    if filetype == 'c':
      flags += ['-xc']
    elif filetype == 'cpp':
      flags += ['-x', 'c++']
      flags += ['-std=c++11']
      flags += cpp_includes
    elif filetype == 'objc':
      flags += ['-ObjC']

    cwd = os.path.abspath(data['getcwd()'])

    include_dirs = ['include'] #, 'src', 'test', 'tests']
    # Add flags from include dirs in current workspace
    for dir_ in include_dirs:
      for dirpath, dirnames, files in os.walk(cwd):
        if dirpath.endswith(dir_):
          flags.extend(['-I' + dirpath])
    flags = MakeRelativePathsInFlagsAbsolute( flags, cwd )
  except KeyError:
      pass

  return {
    'flags': flags,
    'do_cache': True
  }
