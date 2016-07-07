import os
import shutil


class DotFile:
    """
    This class represent dotfile module :)
    :param name: module name
    :param files: module files
    :param directories:  module directories
    :type name: str
    """

    def __init__(self, name: str, files: list[str], directories: list[str],
                 is_customize: bool = False):
        self.name = name

        print("[{0}] install {0} configuration".format(self.name))
        for file in files:
            if is_customize:
                if input("[{0}] do want to install {1} ?[Y/n]".format(
                        self.name, file)) != "Y":
                    continue
            self.file_linker(file)

        for directory in directories:
            if is_customize:
                if input("[{0}] do want to install {1} ?[Y/n]".format(
                        self.name, directory)) != "Y":
                    continue
            self.directory_linker(directory)
        print("{:*^80}".format(''))

    def file_linker(self, file, is_hidden=True):
        dst_file = ('.' if is_hidden else '') + file
        src_file = file

        dst_path = os.path.join(home_dir, dst_file)
        src_path = os.path.join(os.path.join(current_dir, self.name),
                                src_file)

        create_link = True

        if os.path.isfile(dst_path) or os.path.islink(dst_path):
            print('[{0}] {1} already existed'.format(self.name, file))

            if input('do you want to remove {} ?[Y/n] '.format(
                    dst_path)) != "Y":
                create_link = False
            else:
                os.remove(dst_path)

        if create_link:
            os.symlink(src_path, dst_path)
            print("[{0}] Symbolic link created successfully form {1} in {2}"
                  .format(self.name, src_path, dst_path))

    def directory_linker(self, directory, is_hidden=True):
        dst_directory = ('.' if is_hidden else '') + directory
        src_directory = directory

        dst_path = os.path.join(home_dir, dst_directory)
        src_path = os.path.join(os.path.join(current_dir, self.name),
                                src_directory)

        create_link = True

        if os.path.isdir(dst_path) or os.path.islink(dst_path):
            print('[{0}] {1} already existed'.format(self.name, directory))

            if input('do you want to remove {} ?[Y/n] '.format(
                    dst_path)) != "Y":
                create_link = False
            else:
                if os.path.islink(dst_path):
                    os.remove(dst_path)
                elif os.path.isdir(dst_path):
                    shutil.rmtree(dst_path)

        if create_link:
            os.symlink(src_path, dst_path)
            print("[{0}] Symbolic link created successfully form {1} in {2}"
                  .format(self.name, src_path, dst_path))


###########################

do_customization = False

home_dir = os.environ['HOME']
print("[pre] Home directory found at {}".format(home_dir))

current_dir = os.getcwd()
print("[pre] Current directory found at {}".format(current_dir))

###########################

if input('[pre] do you want to customize installation ? [Y/n]') == "Y":
    do_customization = True

###########################

# VIM
DotFile('vim', files=['vimrc'], directories=['vim'])

###########################

# Conf
module = 'conf'
print("[{0}] install {0} configuration".format(module))

# .zshrc
file_linker(module, 'zshrc')

# .dircolors
file_linker(module, 'dircolors')

# .aria2.conf
directory_linker(module, 'aria2')

# .copyrighter
directory_linker(module, 'copyrighter')

# .wakatime.cfg
file_linker(module, 'wakatime.cfg')

# .tmux.conf
file_linker(module, 'tmux.conf')

# .tmux
directory_linker(module, 'tmux')

# .pinerc
file_linker(module, 'pinerc')

# signature
file_linker(module, 'signature')

# .eslintrc
file_linker(module, 'eslintrc.json')

print("{:*^80}".format(''))

###########################

# Git
module = 'git'
print("[{0}] install {0} configuration".format(module))

# .gitconfig
file_linker(module, 'gitconfig')

# .gitignore
file_linker(module, 'gitignore')

print("{:*^80}".format(''))

###########################

# Executable
module = 'bin'
print("[{0}] install {0} configuration".format(module))

# bin
directory_linker(module, 'bin', False)

print("{:*^80}".format(''))
