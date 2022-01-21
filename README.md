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
