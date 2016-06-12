# In The Name Of God
# ========================================
# [] File Name : install.py
#
# [] Creation Date : 11/3/15
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
__author__ = 'Parham Alvani'

import os
import shutil

def file_linker(module, file, is_hidden=True):
    dst_file = ('.' if is_hidden else '') + file
    src_file = file

    create_link = True

    if os.path.isfile(os.path.join(home_dir, dst_file)) or \
            os.path.islink(os.path.join(home_dir, dst_file)):
        print('[{0}] {1} already existed'.format(module, src_file))

        if input('do you want to remove {} ?[Y/n] '.format(src_file)) != "Y":
            create_link = False
        else:
            os.remove(os.path.join(home_dir, dst_file))

    if create_link:
        os.symlink(os.path.join(os.path.join(current_dir, module),
                                src_file), os.path.join(home_dir, dst_file))
        print("[{0}] Symbolic link created successfully form {1} in {2}".format(module,
                                                                                os.path.join(
                                                                                    os.path.join(
                                                                                        current_dir, module),
                                                                                    src_file),
                                                                                os.path.join(home_dir, dst_file)))


def directory_linker(module, directory, is_hidden=True):
    dst_directory = ('.' if is_hidden else '') + directory
    src_directory = directory

    create_link = True

    if os.path.isdir(os.path.join(home_dir, dst_directory)) or \
            os.path.islink(os.path.join(home_dir, dst_directory)):
        print('[{0}] {1} already existed'.format(module, directory))

        if input('do you want to remove {} ?[Y/n] '.format(src_directory)) != "Y":
            create_link = False
        else:
            if os.path.islink(os.path.join(home_dir, dst_directory)):
                os.remove(os.path.join(home_dir, dst_directory))
            elif os.path.isdir(os.path.join(home_dir, dst_directory)):
                shutil.rmtree(os.path.join(home_dir, dst_directory))

    if create_link:
        os.symlink(os.path.join(os.path.join(current_dir, module), src_directory),
                   os.path.join(home_dir, dst_directory))
        print("[{0}] Symbolic link created successfully form {1} in {2}".format(module,
                                                                                os.path.join(
                                                                                    os.path.join(
                                                                                        current_dir, module),
                                                                                    src_directory),
                                                                                os.path.join(home_dir,
                                                                                             dst_directory)))


###########################

home_dir = os.environ['HOME']
print("[pre] Home directory found at {}".format(home_dir))

current_dir = os.getcwd()
print("[pre] Current directory found at {}".format(current_dir))

###########################

# VIM
module = 'vim'
print("[{0}] install {0} configuration".format(module))

# .vimrc
file_linker(module, 'vimrc')

# .vim
directory_linker(module, 'vim')

print("{:*^80}".format(''))

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
