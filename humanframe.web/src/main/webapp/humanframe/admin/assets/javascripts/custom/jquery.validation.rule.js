//only alphabet
$.validator.addMethod("isalpha", function(v, e) {
    return this.optional(e) || /^[A-Za-z]*$/g.test(v);
});

//only numeric
$.validator.addMethod("isnumeric", function(v, e) {
    return this.optional(e) || /^[0-9]*$/g.test(v);
});

//only numeric + dot
$.validator.addMethod("isnumericdot", function(v, e) {
    return this.optional(e) || /^[0-9|\.]*$/g.test(v);
});

//only korean charactor
$.validator.addMethod("iskorean", function(v, e) {
    return this.optional(e) || /^[ㄱ-ㅎ|가-힣]*$/g.test(v);
});

//only special charactor
$.validator.addMethod("isspecial", function(v, e) {
    return this.optional(e) || /^[\~\!\@\#\$\%\^\&\*\(\)\_\+\=\-\`\{\}\[\]\|\\\:\"\;\'\<\>\?\,\.\/]*$/g.test(v);
});

//only alphabet, numeric
$.validator.addMethod("isalphanumeric", function(v, e) {
    return this.optional(e) || (/[A-Za-z]/g.test(v) && /[0-9]/g.test(v) && !/[\~\!\@\#\$\%\^\&\*\(\)\_\+\=\-\`\{\}\[\]\|\\\:\"\;\'\<\>\?\,\.\/]/g.test(v) && !/[ㄱ-ㅎ|가-힣]/g.test(v));
});

//only alphabet, numeric, special charactor
$.validator.addMethod("isalphanumericspecial", function(v, e) {
    return this.optional(e) || /^[A-Za-z0-9\~\!\@\#\$\%\^\&\*\(\)\_\+\=\-\`\{\}\[\]\|\\\:\"\;\'\<\>\?\,\.\/]*$/g.test(v);
});

//check email id
$.validator.addMethod("isemailid", function(v, e) {
    return this.optional(e) || /^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*$/g.test(v);
});

//check email domain
$.validator.addMethod("isemaildomain", function(v, e) {
    return this.optional(e) || /^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[.]{1}[A-Za-z]{2,5}$/g.test(v);
});

//validation rule for email
$.validator.addMethod("isemail", function(v, e) {
    return this.optional(e) || /^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[@]{1}[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[.]{1}[A-Za-z]{2,5}$/g.test(v);
});

//GIS
$.validator.addMethod("isgis", function(v, e) {
    return this.optional(e) || /^\d+\.\d+$/g.test(v);
});

//url (include protocol)
$.validator.addMethod("ishttpurl", function(v, e) {
    return this.optional(e) || /((http|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\wㄱ-ㅎㅏ-ㅣ가-힣\;\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?)/g.test(v);
});

//url (not include protocol)
$.validator.addMethod("isurl", function(v, e) {
    return this.optional(e) || /([\w\-_]+(\.[\w\-_]+)+([\wㄱ-ㅎㅏ-ㅣ가-힣\;\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?)/g.test(v);
});

//Not Equals
$.validator.addMethod("notEqualTo", function(v, e, p) {
	return this.optional(e) || v != $(p).val();
});

//include String
$.validator.addMethod("includeString", function(v, e, p) {
	var bIncludeString = false;
	if (v.search(new RegExp($(p).val(), "g")) > -1) {
		bIncludeString = true;
    }
	return (!bIncludeString);
});

//include Char
$.validator.addMethod("includeChar", function(v, e, p) {
	var bIncludeChar = false;
	var targetValue = $(p).val();
	for (var i = 0, iLen = v.length ; i < iLen ; i++) {
        if (targetValue.search(new RegExp(v.charAt(i), "g")) > -1) {
        	bIncludeChar = true;
            break;
        }
    }
	return (!bIncludeChar);
});

//check byte
$.validator.addMethod("maxbyte", function(v, e, p) {
	var b = 0;
	if (v.length > 0) {
		for (var i = 0, iCnt = v.length ; i < iCnt ; i++) {
			var charCode = v.charCodeAt(i);
	        if (charCode <= 0x00007F) {
	        	b += 1;
	        } else if (charCode <= 0x0007FF) {
	        	b += 2;
	        } else if (charCode <= 0x00FFFF) {
	        	b += 3;
	        } else {
	        	b += 4;
	        }
		}
	}
	return (p >= b) ? true : false;
});