(function(){var e,i,t,r,a;r=function(e){return Notification.show(e),!0},a=function(e){return Notification.show(e),!0},e=function(e){var i,t,c,o,n,u;return e.preventDefault(),c=$(e.target),t=c.attr("email"),i=c.attr("camera_id"),u="minimal",o=function(){return r("Add camera to my shared cameras failed."),!1},n=function(e){return e.success?a("Successfully added to your shared cameras."):r("duplicate_share_error"===e.code?"You've already added this camera.":"Failed to add camera to your shared cameras."),!0},window.Evercam.Share.createShare(i,t,u,n,o),!0},t=function(){return $.removeCookie("public-style"),$.cookie("public-style","list",{expires:365})},i=function(){return $.removeCookie("public-style"),$.cookie("public-style","grid",{expires:365})},window.initializePublic=function(){return $(".create-share-button").click(e),$("#grid-style").click(i),$("#list-style").click(t),Notification.init(".bb-alert")}}).call(this);