bitcoin-repo:
  pkgrepo.managed:
   - ppa: bitcoin/bitcoin

bitcoin-pkg:
  pkg.latest:
    - name: bitcoind
    - require:
      - pkgrepo: bitcoin-repo

bitcoin-user:
  user.present:
      - name: bitcoinuser
      - home: /home/bitcoinuser
      - shell: '/bin/bash'
      - password: '!'

/home/bitcoinuser/.bitcoin/bitcoin.conf:
  file.managed:
    - source: salt://btc_node/bitcoin.conf
    - user: bitcoinuser
    - group: bitcoinuser
    - mode: 600
    - makedirs: True
    - template: jinja
    - require:
      - user: bitcoin-user

btc-upstart-conf:
  file.managed:
    - name: /etc/init/bitcoind.conf
    - source: salt://btc_node/btc_upstart.conf
    - require:
      - user: bitcoin-user

btc-upstart-reload:
  cmd.wait:
    - name: initctl reload-configuration
    - watch:
      - file: btc-upstart-conf

btc-service:
  service.running:
    - name: bitcoind
    - require:
      - pkg: bitcoind
      - file: /etc/init/bitcoind.conf