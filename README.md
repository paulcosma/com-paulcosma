# paulcosma.com

Windows Install
```bash
choco install hugo-extended
choco upgrade hugo-extended
```

Linux Install
```bash
# Snap
sudo snap install hugo --channel=extended
# Debian/Ubuntu
sudo apt-get install hugo
# Arch
sudo pacman -Syu hugo
# Linux latest version From source https://gohugo.io/installation/linux/
wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.zshrc
go version
go install -tags extended github.com/gohugoio/hugo@latest
hugo version
export PATH=$PATH:/root/go/bin/
echo "export PATH=$PATH:/root/go/bin/" >> ~/.zshrc
```

Generate a new site
```bash
hugo new site paulcosma.com
```

Download a theme
```bash
git submodule add https://github.com/Track3/hermit.git themes/hermit
```

Add some content. You can add single files with
```bash
hugo new <SECTIONNAME>\<FILENAME>.<FORMAT>
```

Start the built-in live server via
```bash
hugo server
# start and access hugo on a remote server
hugo server --bind=10.2.48.1 --baseURL=http://10.2.48.1:1313
hugo server --bind=10.2.48.1 --baseURL=http://10.2.48.1:1313 -D
```

Keep your regular pages in the content folder.<br>
To create a new page, run
```bash
hugo new page-title.md
```
Keep your blog posts in the content/posts folder.<br>
To create a new post, run
```bash
hugo new posts/post-title.md
# By default, the posts that are being created in your content folder have draft set as true. Hugo will not show these as web pages by default. Start hugo locally with --buildDrafts
hugo server -D
# Replace `true` with `false` for draft when you need your post to be visible.
```

SVG Icons <br>
https://iconify.design/icon-sets/?query=angular

Clone with submodules:
```bash
git clone https://github.com/paulcosma/com-paulcosma.git
cd com-paulcosma
git submodule update --init --recursive
```

Generate Images:
https://www.generateit.net/email-to-image/index.php

Docs:
https://gohugo.io/content-management/organization/
