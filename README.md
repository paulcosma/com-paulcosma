# paulcosma.com

Windows Install
```
choco install hugo-extended
choco upgrade hugo-extended
```

Generate a new site
```
hugo new site paulcosma.com
```

Download a theme 
```
git submodule add https://github.com/paulcosma/hermit.git themes/hermit
```

Add some content. You can add single files with 
```
hugo new <SECTIONNAME>\<FILENAME>.<FORMAT>
```

Start the built-in live server via
```
hugo server
```

Keep your regular pages in the content folder.<br> 
To create a new page, run 
```
hugo new page-title.md
```
Keep your blog posts in the content/posts folder.<br> 
To create a new post, run 
```
hugo new posts/post-title.md
```

SVG Icons <br>
https://iconify.design/icon-sets/?query=angular

Clone with submodules:
```
git clone git@home-github.com:paulcosma/com.paulcosma.git
cd com.paulcosma
git submodule update --init --recursive
```

Generate Images:
https://www.generateit.net/email-to-image/index.php