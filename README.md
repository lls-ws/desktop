<h1 align="center">
  Desktop
</h1>

<h4 align="center">
  Lubuntu 26.04 (Resolute Raccoon)
  7.0.0-22-generic
</h4>


## Usage

### From Command Line

```bash
git clone https://github.com/lls-ws/desktop.git && cd desktop
```

### For Lubuntu Desktop
```bash
bash bin/desktop_config.sh all
```

### To Backup User Preferences

```bash
backup_user
```

### For Ubuntu Server

```bash
sudo bash bin/server_config.sh net
```
```bash
sudo bash bin/server_config.sh ssh
```
```bash
sudo bash bin/server_config.sh grub
```
```bash
sudo bash bin/server_config.sh conf
```
```bash
sudo bash bin/server_config.sh profile
```
#### On Local PC
```bash
sudo bash bin/server_config.sh key
```
#### On Ubuntu Server
```bash
sudo bash bin/server_config.sh remote
```
```bash
sudo bash util/install/transmission.sh install
```
```bash
sudo bash util/install/dlna.sh install
```
```bash
sudo bash util/install/docker.sh install
```
```bash
sudo bash util/install/nfs.sh install
```
```bash
sudo bash bin/server_config.sh script
```
#### On Local PC
```bash
sudo bash util/install/nfs.sh local
```

## License

See [LICENSE](LICENSE).
