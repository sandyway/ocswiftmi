/**
 * 微型模板引擎 tmpl
 * 方式：直接传入模板：(可以随心所欲的使用js原生语法)
 */
var tmpl = (function (cache, $) {
    return function (str, data) {
        var fn = function (data) {
            var i, variable = [$], value = [[]];
            for (i in data) {
                variable.push(i);
                value.push(data[i]);
            };
            return (new Function(variable, fn.$))
            .apply(data, value).join("");
        };

        fn.$ = fn.$ || $ + ".push('"
        + str.replace(/\\/g, "\\\\")
                 .replace(/[\r\t\n]/g, " ")
                 .split("<#").join("\t")
                 .replace(/((^|#>)[^\t]*)'/g, "$1\r")
                 .replace(/\t=(.*?)#>/g, "',$1,'")
                 .split("\t").join("');")
                 .split("#>").join($ + ".push('")
                 .split("\r").join("\\'")
        + "');return " + $;

        return data ? fn(data) : fn;
    }
})({}, '$' + (+new Date));

tmpl.render = function (id, data) {
  
    var t = document.getElementById(id).innerHTML;
    
    var c = tmpl(t, data);
    return c;
}


            Date.prototype.format = function (fmt) { //author: meizz
            var o = {
            "M+": this.getMonth() + 1, //鏈堜唤
            "d+": this.getDate(), //鏃�
            "h+": this.getHours(), //灏忔椂
            "m+": this.getMinutes(), //鍒�
            "s+": this.getSeconds(), //绉�
            "q+": Math.floor((this.getMonth() + 3) / 3), //瀛ｅ害
            "S": this.getMilliseconds() //姣
            };
            if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            return fmt;
            };