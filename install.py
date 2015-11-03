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


def file_linker(module, file):
    create_link = True
    if os.path.isfile(os.path.join(home_dir, '.' + file)) or os.path.islink(os.path.join(home_dir, '.' + file)):
        print('[{0}] {1} already existed'.format(module, file))
        if input('do you want to remove {} ?[Y/n] '.format(file)) != "Y":
            create_link = False
        else:
            os.remove(os.path.join(home_dir, '.' + file))
    if create_link:
        os.symlink(os.path.join(os.path.join(current_dir, module),
                                file), os.path.join(home_dir, '.' + file))
        print("[{0}] Symbolic link created successfully form {1} in {2}".format(module,
                                                                                os.path.join(
                                                                                    os.path.join(
                                                                                        current_dir, module),
                                                                                    file),
                                                                                os.path.join(home_dir, '.' + file)))


def directory_linker(module, directory):
    create_link = True
    if os.path.isdir(os.path.join(home_dir, '.' + directory)) or os.path.islink(
            os.path.join(home_dir, '.' + directory)):
        print('[{0}] {1} already existed'.format(module, directory))
    if input('do you want to remove {} ?[Y/n] '.format(directory)) != "Y":
        create_link = False
    else:
        if os.path.islink(os.path.join(home_dir, '.' + directory)):
            os.remove(os.path.join(home_dir, '.' + directory))
        elif os.path.isdir(os.path.join(home_dir, '.' + directory)):
            shutil.rmtree(os.path.join(home_dir, '.' + directory))
    if create_link:
        os.symlink(os.path.join(os.path.join(current_dir, module),
                                directory), os.path.join(home_dir, '.' + directory))
        print("[{0}] Symbolic link created successfully form {1} in {2}".format(module,
                                                                                os.path.join(
                                                                                    os.path.join(
                                                                                        current_dir, module),
                                                                                    directory),
                                                                                os.path.join(home_dir,
                                                                                             '.' + directory)))


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
