# Publish a Package on PyPI
### Mostly adapted from [Real Python Article](https://realpython.com/pypi-publish-python-package/)

1. create `setup.cfg`
    ```
    [metadata]
    requires-dist =
        markdown-it-py
        beautifulsoup4
        html5lib

    long_description = file: README.md
    long_description_content_type = text/markdown
    ```
2. create `setup.py`
    ```
    from setuptools import setup
    setup(
        name="package_name",
        version="0.0.2",
        license="gpl-3.0",
        author="John Hupperts",
        author_email="jrock4503@hotmail.com",
        url="https://github.com/treatmesubj/repo",
        download_url="https://github.com/treatmesubj/repo/archive/refs/tags/v0.0.2.tar.gz",
        packages=["package_name"],
        package_dir={"local_dir": "code_dir"},
        project_urls={
            "Source": "https://github.com/treatmesubj/repo"
        },
        install_requires=[
            "markdown-it-py",
            "beautifulsoup4",
            "html5lib"
        ],
    )
    ```
3. `python -m pip install build twine`
4. `python -m build`
5. `twine check dist/*` 
6. `twine upload dist/*`
