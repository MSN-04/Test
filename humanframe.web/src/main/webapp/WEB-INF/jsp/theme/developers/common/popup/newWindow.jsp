<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<c:if test="${not empty popupList}">
<script>
$(function() {
<c:forEach items="${popupList}" var="popup" varStatus="status">
<c:set var="popupTargetId" value="popup_ctrl_${popup.popupNo}"/>
<c:if test="${popup.popupTy eq '1' and empty cookie[popupTargetId]}">
	var popup${popup.popupNo} = window.open("/comm/popup/${popup.popupNo}", "popupNewWin${popup.popupNo}", "width=${popup.popupWidth},height=${popup.popupHeight},top=${popup.popupTop},left=${popup.popupLeft},resizable=no,status=no,location=no,directories=no,toolbar=no,menubar=no,scrollbars=no");
	popup${popup.popupNo}.focus();
</c:if>
</c:forEach>
});
</script>
</c:if>