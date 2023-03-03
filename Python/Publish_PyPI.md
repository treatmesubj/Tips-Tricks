# Publish a Package on PyPI
### Mostly adapted from [Real Python Article](https://realpython.com/pypi-publish-python-package/)

1. create `setup.cfg`
    ```
    [metadata]
    license_files = LICENSE.txt
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
3. create `pyproject.toml`
    ```
    [build-system]
    requires = [
        "setuptools",
        "wheel"
    ]
    build-backend = "setuptools.build_meta"
    ```
4. `python -m pip install build twine`
5. `python -m build`
6. `twine check dist/*` 
7. `twine upload dist/*`
