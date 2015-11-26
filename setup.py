import site
import os
curdir = os.getcwd()

from op5lib import setup

os.chdir(curdir)

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

setup(
    name='op5-cli',
    version='0.1',
    author='Ozan Safi',
    author_email='ozansafi@gmail.com',
    scripts=['op5-cli'],
    data_files=[(site.getuserbase()+"/man/man1/", ['man/op5-cli.1'])],
    url='https://github.com/ozans/op5-cli',
    license='LICENSE.txt',
    description='A command-line interface for the OP5 monitoring system',
    long_description=open('README.txt').read(),
    install_requires=[
        "PyYAML>=3.11",
        "argparse>=1.2.1",
        "requests>=2.3.0",
        "termcolor>=1.1.0",
        "keyring>=5.4"
    ],
)
