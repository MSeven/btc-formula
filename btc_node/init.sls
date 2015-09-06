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

btc-systemd-conf:
  file.managed:
    - name: /lib/systemd/system/bitcoind.service
    - source: salt://btc_node/btc_systemd.service
    - require:
      - user: bitcoin-user

btc-service:
  service.running:
    - name: bitcoind
    - require:
      - pkg: bitcoind
      - file: /lib/systemd/system/bitcoind.service
