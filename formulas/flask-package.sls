python-pip:
  pkg.installed

git:
  pkg.installed

flask:
  pip.installed:
    - name: Flask
    
gunicorn:
  pip.installed:
    - name: gunicorn


clone flask app:
  cmd.run:
    - name: 'git clone https://github.com/sergioaguila/salt-test.git /opt/salt-test'

export app:
  cmd.run:
    - name: cd /opt/salt-test/app; gunicorn -b 0.0.0.0:80  -w 1 -D hello:Flask
