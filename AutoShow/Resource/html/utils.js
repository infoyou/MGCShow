// JavaScript Document

   function IsEmail(strg) {
        var patrn = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
        if (!patrn.exec(strg))
            return false;
        return true
    }
	
/**
中文 英文大小写 数字 中划线 下划线 空格 全角


*/

function isChinaOrNumbOrLett(s){
//    var regu = "^[0-9a-zA-Z\u4e00-\u9fa5\uFE30-\uFFA0\-_ ]+$";
    var regu = '/^[a-zA-Z0-9_\u4e00-\u9fa5\" "]+$/';
    var re = new RegExp(regu);
    if (/^[a-zA-Z0-9_\u4e00-\u9fa5\" "]+$/.test(s)) {
        return true;
    }
    else {
        return false;
    }
}

/**
 * 全角转半角
 * @param str
 * @returns {String}
 */
function ToCDB(str){ 
	var tmp = ""; 
	for(var i=0;i<str.length;i++) { 
		if(str.charCodeAt(i)>65248&&str.charCodeAt(i)<65375){ 
			tmp += String.fromCharCode(str.charCodeAt(i)-65248); 
		}else { 
			tmp += String.fromCharCode(str.charCodeAt(i)); 
		} 
	} 
	return tmp 
}