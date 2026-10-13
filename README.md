# Jenkins Module 2 + Module 3 Practice Project

This project reuses the simple Python app and tests from Module 2 and adds a
Declarative Jenkinsfile for Module 3.

## Files

- `app.py`: small Python application
- `tests/test_app.py`: two pytest tests
- `.gitignore`: excludes virtual environments and generated files
- `Jenkinsfile`: checkout, install, test, package, and post-build actions

## Run locally on Ubuntu

From this project directory:

```bash
python3 --version
python3 -m venv .venv
.venv/bin/python -m pip install pytest
.venv/bin/python -m pytest -v
python3 app.py
```

If creating a virtual environment fails because the venv package is missing:

```bash
sudo apt update
sudo apt install -y python3-venv
```

## Push to GitHub

Create an empty GitHub repository, then run these commands from this directory
(replace the URL with your own repository URL):

```bash
git init
git add .
git commit -m "Add Jenkins Modules 2 and 3 practice project"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

If you already have a Git repository configured, check `git remote -v` first and
do not add a duplicate remote.

## Configure Jenkins

1. Create a new item named `Python-Pipeline-CI`.
2. Choose **Pipeline**.
3. In the Pipeline section, choose **Pipeline script from SCM**.
4. Set SCM to **Git**.
5. Enter your repository URL and branch (usually `*/main`).
6. Set Script Path to `Jenkinsfile`.
7. Save and choose **Build with Parameters**.
8. Select `RUN_TESTS = yes` for the first run.

The Jenkins execution machine needs Python 3, permission to write to its workspace,
and access to the Git repository. The `junit` step requires the Jenkins JUnit
plugin. Do not commit passwords or access tokens into this repository.
