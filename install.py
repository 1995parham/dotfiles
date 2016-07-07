import os
import shutil


class DotFile:
    """
    This class represent dotfile module :)

    :param name: module name
    :param files: module files
    :param directories:  module directories
    :type name: str
    :type files: list[str]
    :type directories: list[str]
    """

    def __init__(self, name, files, directories,
                 is_customize: bool = False, is_hidden: bool = False):
        self.name = name

        print("[{0}] install {0} configuration".format(self.name))
        for file in files:
            if is_customize:
                if input("[{0}] do want to install {1} ?[Y/n]".format(
                        self.name, file)) != "Y":
                    continue
            self.file_linker(file, is_hidden)

        for directory in directories:
            if is_customize:
                if input("[{0}] do want to install {1} ?[Y/n]".format(
                        self.name, directory)) != "Y":
                    continue
            self.directory_linker(directory, is_hidden)
        print("{:*^80}".format(''))

    def file_linker(self, file: str, is_hidden: bool = True):
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

    def directory_linker(self, directory: str, is_hidden: bool = True):
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
DotFile('vim', files=['vimrc'], directories=['vim'],
        is_customize=do_customization)

###########################

# Conf
DotFile('conf',
        files=['zshrc', 'dircolors', 'wakatime.cfg', 'tmux.conf',
               'pinerc', 'signature', 'eslintrc.json'],
        directories=['copyrighter, aria2', 'tmux'],
        is_customize=do_customization)

###########################

# Git
DotFile('git', files=['gitconfig', 'gitignore'],
        directories=[],
        is_customize=do_customization)

###########################

# Executable
module = 'bin'
DotFile('bin', files=[], directories=['bin'],
        is_hidden=False, is_customize=do_customization)
