python-pip:
  pkg.installed

git:
  pkg.installed

flask:
  pip.installed:
    - name: Flask

clone flask app:
  cmd:
    - run
    - unless: test -d /opt/chefk-test
    - name: >
              git clone https://github.com/sergioaguila/salt-test.git /opt/
              export FLASK_APP='/opt/salt-test/app/hello.py'
              flask run --port=80 --host='0.0.0.0'