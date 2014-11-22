bitcoin-repo:
  pkgrepo.managed:
   - ppa: bitcoin/bitcoin

bitcoin-pkg:
  pkg.latest:
    - name: bitcoind
    - require:
      - pkgrepo: bitcoin-repo

btc-supervisor-pkg:
  pkg:
    - name: supervisor
    - installed
  service:
    - name: supervisor
    - running
    - enable: True
    - watch:
      - pkg: supervisor
      - file: btc-supervisor-conf

bitcoin-user:
  user.present:
      - name: bitcoinuser
      - home: /home/bitcoinuser
      - shell: '/bin/bash'
      - password: '!'

/home/bitcoinuser/.bitcoin/bitcoin.conf:
  file.managed:
    - source: salt://btc-node/bitcoin.conf
    - user: bitcoinuser
    - group: bitcoinuser
    - mode: 600
    - makedirs: True
    - template: jinja
    - require:
      - user: bitcoin-user

btc-supervisor-conf:
  file.managed:
    - name: /etc/supervisor/conf.d/bitcoin.conf
    - source: salt://btc-node/btc_supervisor.conf
    - require:
      - user: bitcoin-user

supervisorctl_reload:
  cmd.wait:
    - name: supervisorctl reload
    - watch:
      - file: btc-supervisor-conf