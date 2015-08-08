/// <reference path="jquery-1.8.3.min.js" />
/// <reference path="tmpl.js" />
;
(function () {

 moment.lang("zh-cn");
 template.helper('Date', Date);
 template.helper('moment', moment);

    var converter1 = Markdown.getSanitizingConverter();
    template.helper("md", converter1);

    var article = {
        isNight: 0,
        render: function (art) {

            if (!art.comments) {
                art.comments = [];
            }
            if (!art.code.createTime) {
                art.code.createTime = parseInt((new Date()).getTime() / 1000);
            }

            var con = template("content-tmpl", art);
            $("#content").html(con);
            hljs.initHighlighting();
 
 if(window.githubWidget){
 window.githubWidget();
 }
  
            window.location.href = "html://contentready";

            return 1;
        },

        setFontSize: function (sizeName) {

            $("body")[0].className = "body f" + sizeName;
            article.setNightMode(article.isNight);
            return 1;
        },

        setNightMode: function (isNight) {
            article.isNight = isNight;
            if (isNight) {
                $("body").addClass("night");
            }
            else {
                $("body").removeClass("night");
            }
            return 1;
        },
        addComment:function(comment){
            comment.index=$("#replies").find("dl").length;
            var con = template("comment-tmpl",{comment:comment});
            $("#replies").append(con);

            $(document).scrollTop($(document).height());
        }
    };

    window.article = article;
    $(document).ready(function () {
        window.location.href = "html://docready";
    });
})();