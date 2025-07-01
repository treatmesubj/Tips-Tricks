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
    from pathlib import Path


    this_directory = Path(__file__).parent
    long_description = (this_directory / "README.md").read_text()

    setup(
        name="package_name",
        version="0.0.2",
        license="gpl-3.0",
        author="John Hupperts",
        author_email="jrock4503@hotmail.com",
        description="it's a cool package",
        long_description=long_description,
        long_description_content_type="text/markdown",
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
4. `git add .`, `git commit -m "v0.0.2"`, `git push`
5. Create GitHub release w/ title and tag as `v0.0.2`
6. `python -m pip install build twine`
7. `python -m build`
8. `twine check dist/*`
9. `twine upload dist/*`
    - see `https://pypi.org/help/#apitoken`
    - username: `__token__`
    - password: respective-API-Token
