<h1 align="center">
  Desktop
</h1>

<h4 align="center">
  Lubuntu 25.10 (Questing Quokka)
  6.17.0-6-generic
</h4>


## Usage

### From Command Line

```bash
git clone https://github.com/lls-ws/desktop.git && cd desktop
```

### For Lubuntu Desktop
```bash
sudo bash bin/lubuntu_config.sh all
```

### For Ubuntu Server 26.04 LTS

```bash
sudo bash bin/dell_config.sh net
```
```bash
sudo bash bin/dell_config.sh ssh
```
```bash
sudo bash bin/dell_config.sh grub
```
```bash
sudo bash bin/dell_config.sh conf
```
#### On Local PC
```bash
sudo bash bin/dell_config.sh key
```
#### On Ubuntu Server
```bash
sudo bash bin/dell_config.sh remote
```
```bash
sudo bash bin/dell_config.sh transmission
```
```bash
sudo bash bin/dell_config.sh dlna
```
```bash
sudo bash bin/dell_config.sh nfs
```

### To Backup User Preferences

```bash
backup_user
```

## License

See [LICENSE](LICENSE).
