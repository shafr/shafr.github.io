---
layout: post
title:  "Storing SSH keys in TPM (for github and other things)"
tags: ['git', 'ssh', 'code sign']
categories: work
---

It would be a TLDR version, if you need more info, go to the links section below.

* If you are using Mac OS - you can use [Secretive](https://github.com/maxgoedjen/secretive) - generate new keys, use fingerprint for when using keys, store them in secure enclave
* If you are using windows - there's [nCrypt](https://github.com/unreality/nCryptAgent)

* If you are using Linux it's much more interesting. Let's install this tool & try adding keys. 
Note if you are adding userpin, you'll have to enter it every time you push/fetch code in vs code:

```bash
sudo apt install libtpm2-pkcs11-tools libtpm2-pkcs11-1
sudo usermod -a -G tss '$(id -nu)'
tpm2_ptool init
tpm2_ptool addtoken --pid=1 --label=my_key --userpin='' --sopin='recovery_password'
tpm2_ptool addkey --label=my_key --userpin='' --algorithm=rsa2048
```

From here you should update your ~/.ssh/config:
```bash
Host github.com
  HostName github.com
  User git
  PKCS11Provider /usr/lib/x86_64-linux-gnu/libtpm2_pkcs11.so.1
  ForwardAgent yes
  PasswordAuthentication no
```

And if you want for signatures to be working (local repo example .git/config):
```bash
[user]
	signingkey = ~/.ssh/signing/key.pub

[commit]
	gpgsign = true
	verbose = true

[tag]
	gpgsign = true

[gpg]
	format = ssh

[gpg.ssh]
	allowedSignersFile = ~/.config/git/allowed_signers
```


## Sources, lots of them:
* [TPM + SSH](https://blog.ledger.com/ssh-with-tpm)
* [Gentoo TPM+SSH](https://wiki.gentoo.org/wiki/Trusted_Platform_Module/SSH)
* [Github + SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
* [VS-code + SSH](https://gist.github.com/carlinmack/c148564e24ce1feee8e1575029052e2c)
* [Vs-code and signing](https://stackoverflow.com/questions/45730815/how-can-i-use-git-commits-signing-in-vs-code)
* [Signing commits via ssh](https://docs.gitlab.com/ee/user/project/repository/signed_commits/ssh.html)
* [Github code signing](https://github.com/aldur/dotfiles/blob/9bd2ad7b810aa91acc3f2611910088872a588282/various/Makefile#L28)
* [Secretive signing](https://github.com/maxgoedjen/secretive/issues/262)
* [TPM basics](https://github.com/nokia/TPMCourse/blob/master/docs/keys.md)

## Troubleshooting
* Github uses .public keys for signing, not private. So it makes no sense to secure generate those.
* for some reason github would not accept public keys generated from TPM. Not sure why.