window.matchMedia=window.matchMedia||function(e){"use strict";var t,n=e.documentElement,a=n.firstElementChild||n.firstChild,s=e.createElement("body"),i=e.createElement("div");return i.id="mq-test-1",i.style.cssText="position:absolute;top:-100em",s.style.background="none",s.appendChild(i),function(e){return i.innerHTML='&shy;<style media="'+e+'"> #mq-test-1 { width: 42px; }</style>',n.insertBefore(s,a),t=42===i.offsetWidth,n.removeChild(s),{matches:t,media:e}}}(document),function(e){"use strict";function t(){w(!0)}var n={};if(e.respond=n,n.update=function(){},n.mediaQueriesSupported=e.matchMedia&&e.matchMedia("only all").matches,!n.mediaQueriesSupported){var a,s,i,r=e.document,o=r.documentElement,l=[],d=[],m=[],h={},u=30,c=r.getElementsByTagName("head")[0]||o,p=r.getElementsByTagName("base")[0],f=c.getElementsByTagName("link"),y=[],v=function(){for(var t=0;f.length>t;t++){var n=f[t],a=n.href,s=n.media,i=n.rel&&"stylesheet"===n.rel.toLowerCase();a&&i&&!h[a]&&(n.styleSheet&&n.styleSheet.rawCssText?(x(n.styleSheet.rawCssText,a,s),h[a]=!0):(!/^([a-zA-Z:]*\/\/)/.test(a)&&!p||a.replace(RegExp.$1,"").split("/")[0]===e.location.host)&&y.push({href:a,media:s}))}g()},g=function(){if(y.length){var t=y.shift();T(t.href,function(n){x(n,t.href,t.media),h[t.href]=!0,e.setTimeout(function(){g()},0)})}},x=function(e,t,n){var a=e.match(/@media[^\{]+\{([^\{\}]*\{[^\}\{]*\})+/gi),s=a&&a.length||0;t=t.substring(0,t.lastIndexOf("/"));var i=function(e){return e.replace(/(url\()['"]?([^\/\)'"][^:\)'"]+)['"]?(\))/g,"$1"+t+"$2$3")},r=!s&&n;t.length&&(t+="/"),r&&(s=1);for(var o=0;s>o;o++){var m,h,u,c;r?(m=n,d.push(i(e))):(m=a[o].match(/@media *([^\{]+)\{([\S\s]+?)$/)&&RegExp.$1,d.push(RegExp.$2&&i(RegExp.$2))),u=m.split(","),c=u.length;for(var p=0;c>p;p++)h=u[p],l.push({media:h.split("(")[0].match(/(only\s+)?([a-zA-Z]+)\s?/)&&RegExp.$2||"all",rules:d.length-1,hasquery:h.indexOf("(")>-1,minw:h.match(/\(\s*min\-width\s*:\s*(\s*[0-9\.]+)(px|em)\s*\)/)&&parseFloat(RegExp.$1)+(RegExp.$2||""),maxw:h.match(/\(\s*max\-width\s*:\s*(\s*[0-9\.]+)(px|em)\s*\)/)&&parseFloat(RegExp.$1)+(RegExp.$2||"")})}w()},E=function(){var e,t=r.createElement("div"),n=r.body,a=!1;return t.style.cssText="position:absolute;font-size:1em;width:1em",n||(n=a=r.createElement("body"),n.style.background="none"),n.appendChild(t),o.insertBefore(n,o.firstChild),e=t.offsetWidth,a?o.removeChild(n):n.removeChild(t),e=i=parseFloat(e)},w=function(t){var n="clientWidth",h=o[n],p="CSS1Compat"===r.compatMode&&h||r.body[n]||h,y={},v=f[f.length-1],g=(new Date).getTime();if(t&&a&&u>g-a)return e.clearTimeout(s),void(s=e.setTimeout(w,u));a=g;for(var x in l)if(l.hasOwnProperty(x)){var T=l[x],C=T.minw,S=T.maxw,$=null===C,b=null===S,R="em";C&&(C=parseFloat(C)*(C.indexOf(R)>-1?i||E():1)),S&&(S=parseFloat(S)*(S.indexOf(R)>-1?i||E():1)),T.hasquery&&($&&b||!($||p>=C)||!(b||S>=p))||(y[T.media]||(y[T.media]=[]),y[T.media].push(d[T.rules]))}for(var M in m)m.hasOwnProperty(M)&&m[M]&&m[M].parentNode===c&&c.removeChild(m[M]);for(var O in y)if(y.hasOwnProperty(O)){var B=r.createElement("style"),L=y[O].join("\n");B.type="text/css",B.media=O,c.insertBefore(B,v.nextSibling),B.styleSheet?B.styleSheet.cssText=L:B.appendChild(r.createTextNode(L)),m.push(B)}},T=function(e,t){var n=C();n&&(n.open("GET",e,!0),n.onreadystatechange=function(){4!==n.readyState||200!==n.status&&304!==n.status||t(n.responseText)},4!==n.readyState&&n.send(null))},C=function(){var t=!1;try{t=new e.XMLHttpRequest}catch(n){t=new e.ActiveXObject("Microsoft.XMLHTTP")}return function(){return t}}();v(),n.update=v,e.addEventListener?e.addEventListener("resize",t,!1):e.attachEvent&&e.attachEvent("onresize",t)}}(this);