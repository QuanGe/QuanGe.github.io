// ==UserScript==
// @name        M3U8 智能保存 油猴脚本
// @author      You
// @version     0.0.1
// @description 请复制此代码，并修改，然后在油猴脚本管理中创建您的油猴脚本, 如果脚本影响了您的正常使用，您应该添加@exclude规则排除某些网站，以便更好的体验
// @match       *://*/*
// ==/UserScript==
 (function() {
    window.shouldAutoSave = GM.info.scriptHandler === "Zipym";
 })();