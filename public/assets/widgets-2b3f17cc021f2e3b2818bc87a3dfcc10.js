(function(){var e;e=function(){var e,i,t,a,r,n,c,d,w,l;return t=$("#widget-camera").val(),d=$("#widget-refresh-rate").val(),l=$("#widget-camera-width").val(),n=$("#widget-authenticate").val(),w=window.location.origin,a=$("#widget-camera option:selected").text(),r=-1!==a.indexOf("(Offline)"),c=-1===a.indexOf("(Private)")?"false":"true",e="true"===n?"&api_id="+window.api_credentials.api_id+"&api_key="+window.api_credentials.api_key:"",i="<div id='ec-container-"+t+"' style='width: "+l+"px'></div> <script src='"+w+"/live.view.widget.js?refresh="+d+"&camera="+t+"&private="+c+e+"' async></script>",$("#code").text(i),document.removeEventListener("visibilitychange",window.ec_vis_handler,!1),null!=window.ec_watcher&&clearTimeout(window.ec_watcher),r||$(".preview").html(i),!0},$(function(){return e(),$("#widget-camera-width").change(e),$("#widget-refresh-rate").change(e),$("#widget-camera").change(e),$("#widget-authenticate").change(e)})}).call(this);