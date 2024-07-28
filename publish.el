(require 'ox)
(require 'ox-publish)

(defvar website-html-head
"<link rel='stylesheet' type='text/css' href='assets/css/common.css'>
<link rel='stylesheet' type='text/css' href='assets/css/main.css'>
<link rel='icon' type='image/png' href='./images/art/personal_logo.png'>
<meta name='viewport' content='width=device-width, initial-scale=.5'>
<meta charset='utf-8'/>
<base target='_blank'/>
<script src='assets/js/vim.js'></script>")

(defvar blog-html-head
"<link rel='stylesheet' type='text/css' href='../assets/css/common.css'>
<link rel='stylesheet' type='text/css' href='../assets/css/blog.css'>
<link rel='icon' type='image/png' href='../images/art/personal_logo.png'>
<meta name='viewport' content='width=device-width, initial-scale=.5'>
<meta charset='utf-8'/>
<base target='_blank'/>
<script src='../assets/js/vim.js'></script>")

(defvar brain-html-head
"<link rel='stylesheet' type='text/css' href='/~abellon/assets/css/common.css'>
<link rel='stylesheet' type='text/css' href='/~abellon/assets/css/brain.css'>
<link rel='icon' type='image/png' href='../images/art/personal_logo.png'>
<meta name='viewport' content='width=device-width, initial-scale=.5'>
<meta charset='utf-8'/>
<base target='_blank'/>
<script src='../assets/js/vim.js'></script>")

(defvar website-html-preamble
"<ul class='header banner'>
    <li><a target='_parent' href='.'>home</a></li>
    <li><a target='_parent' href='./projects.html'>projects</a></li>
    <li><a target='_parent' href='./experience.html'>experience</a></li>
    <li><a target='_parent' href='./blog'>blog</a></li>
    <li><a target='_parent' href='./misc.html'>misc</a></li>
</ul>")

(defvar blog-html-preamble
"<ul class='header banner'>
    <li><a target='_parent' href='.'>home</a></li>
    <li><a target='_parent' href='./projects.html'>projects</a></li>
    <li><a target='_parent' href='./experience.html'>experience</a></li>
    <li><a target='_parent' href='./blog'>blog</a></li>
    <li><a target='_parent' href='./misc.html'>misc</a></li>
</ul>")
<div class='preamble'>
<h1 style='margin-top: 60px;'>%t</h1>
<p class=meta>posted %C</p></div>")

(defvar brain-html-preamble
"<div class='preamble'>
<h1 style='margin-top: 60px;'>%t</h1></div>")

(defvar website-html-postamble
"<div>
    <ul class='footer banner' style='margin-top:0px; margin-bottom:0px;'>
        <span class='footer-container'>
            <span>
                <li><a target='_parent' href='./cv.pdf'>cv</a></li>
                <li><a target='_parent' href='https://github.com/alex-bellon/'>github</a></li>
            </span>
            <span>
                <li><a href='https://lau-mendez.com'>home</a></li>
                <li><a target='_parent' href='https://github.com/lmendezayl/lau-mendez.com'>website source</a></li>
            </span>
        </span>
    </ul>
</div")

(setq org-html-metadata-timestamp-format "%m.%d.%y %H:%M")

(defun sitemap-format-entry (entry style project)
  (cond ((not (directory-name-p entry))
         (let* ((date (org-publish-find-date entry project)))
           (format "[%s] [[file:%s][%s]]"
                   (format-time-string "%y.%m.%d" date) entry
                   (org-publish-find-title entry project))))
        ((eq style 'tree)
         ;; Return only last subdir.
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(setq org-publish-project-alist
    `(("pages"
       :base-directory "~/git/website/src/"
       :base-extension "org"
       :publishing-directory "~/git/website/"
       :publishing-function org-html-publish-to-html
       :section-numbers nil
       :with-toc nil
       :auto-sitemap nil
       :html-head-include-default-style nil
       :html-head-include-scripts nil
       :html-head ,website-html-head
       :html-preamble ,website-html-preamble
       :html-postamble ,website-html-postamble)

      ("blog"
       :base-directory "~/git/website/src/blog/"
       :base-extension "org"
       :recursive t
       :publishing-directory "~/git/website/blog/"
       :publishing-function org-html-publish-to-html
       :section-numbers nil
       :with-author nil
       :with-title nil
       :html-head-include-default-style nil
       :html-head-include-scripts nil
       :html-validation-link nil
       :html-preamble ,blog-html-preamble
       :html-postamble nil
       :html-head ,blog-html-head
            
       :auto-sitemap t
       :auto-sitemap 'cache
       :sitemap-title "blog posts"
       :sitemap-filename "index.org"
       :sitemap-format-entry sitemap-format-entry
       :sitemap-sort-files anti-chronologically)
      
      ("brain"
       :base-directory "~/git/website/src/brain/"
       :base-extension "org"
       :recursive t
       :publishing-directory "~/git/website/brain/"
       :publishing-function org-html-publish-to-html
       :section-numbers nil
       :with-author nil
       :with-title nil
       :with-toc nil
       :html-head-include-default-style nil
       :html-head-include-scripts nil
       :html-validation-link nil
       :html-preamble ,brain-html-preamble
       :html-postamble nil
       :html-head ,brain-html-head
           
       :auto-sitemap t
       :auto-sitemap 'cache
       :sitemap-title "brain"
       :sitemap-filename "index.org")

      ("website" :components ("pages" "blog" "brain"))))

(defun filter-local-links (link backend info)
  "Filter that converts all the /index.html links to /"
  (if (org-export-derived-backend-p backend 'html)
	  (replace-regexp-in-string ".html" "" link)))

;; Do not forget to add the function to the list!
(add-to-list 'org-export-filter-link-functions 'filter-local-links)

(defvar project-name (nth 0 argv))

(cond ((string= project-name "pages")
       (org-publish "pages"))
      ((string= project-name "blog")
       (org-publish "blog"))
      ((string= project-name "brain")
       (org-publish "brain"))
      ((string= project-name "all")
       (org-publish "pages")
       (org-publish "blog")
       (org-publish "brain"))
      (t
       (message "Invalid project name")))
