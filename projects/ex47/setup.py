try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    'description': 'ex47',
    'author': 'Yoshua Elmaryono',
    'url': 'URL to get it at.',
    'download_url': 'Where to download it.',
    'author_email': 'y6326@outlook.com',
    'version': '0.1',
    'install_requires': ['nose'],
    'packages': ['ex47'],
    'scripts': [],
    'name': 'projectname'
}

setup(**config)