<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<c:forEach var="viewObj" items="${bbsTypeVO.viewObject}" varStatus="status">
<c:choose>
	<c:when test="${viewObj.key eq 'ctgryNm' }"><!-- 카테고리 -->
	<c:if test="${bbsTypeVO.ctgryNo > 0 and bbsSettingVO.ctgryUseAt == 'Y'}">
		<c:forEach var="viewDtl" items="${viewObj.value }">
		<tr>
			<th>${viewDtl.key }</th>
			<td>${viewDtl.value}</td>
		</tr>
		</c:forEach>
	</c:if>
	</c:when>

	<c:when test="${viewObj.key eq 'sj' }"><!-- 제목 -->
		<c:forEach var="viewDtl" items="${viewObj.value }">
		<tr>
			<th>${viewDtl.key }</th>
			<td>
				<c:if test="${bbsTypeVO.noticeAt eq 'Y'}"><img src="${themeAssets}/img/icon/icon_notice.gif" alt="<spring:message code='board.notice' />" style="margin-right: 5px;"/></c:if>
				${viewDtl.value}
			</td>
		</tr>
		</c:forEach>
	</c:when>

	<c:when test="${viewObj.key eq 'secretAt' }"><!-- 공개여부 -->
		<c:forEach var="viewDtl" items="${viewObj.value }">
		<tr>
			<th>${viewDtl.key }</th>
			<td>${secretTyCode[viewDtl.value]}</td>
		</tr>
		</c:forEach>
	</c:when>

	<c:when test="${viewObj.key eq 'confmAt' }"><!-- 승인여부 -->
		<c:forEach var="viewDtl" items="${viewObj.value }">
		<tr>
			<th>${viewDtl.key }</th>
			<td>${confmTyCode[viewDtl.value]}</td>
		</tr>
		</c:forEach>
	</c:when>

	<c:when test="${viewObj.key eq 'cclTy' }"><!-- CCL여부 -->
		<c:if test="${bbsSettingVO.cclAt eq 'Y'}">
		<c:forEach var="viewDtl" items="${viewObj.value }">
		<tr>
			<th>${viewDtl.key }</th>
			<td>
				<c:if test="${not empty viewDtl.value}">
					<img src="${themeAssets}/img/lic/lic_${viewDtl.value}.jpg" alt="${viewDtl.value}" /> ${licCode[viewDtl.value-1].codeNm}
				</c:if>
			</td>
		</tr>
		</c:forEach>
		</c:if>
	</c:when>

	<c:when test="${viewObj.key eq 'hashTag' }"><!-- 해시태그 -->
		<c:if test="${bbsSettingVO.hashTagAt eq 'Y'}">
		<c:forEach var="viewDtl" items="${viewObj.value }">
		<tr>
			<th>${viewDtl.key }</th>
			<td>
				<c:if test="${not empty viewDtl.value}">
					<c:forEach items="${fn:split(viewDtl.value, '|')}" var="hashTagValue">
						<a href="#">${hashTagValue}</a>&nbsp;&nbsp;
					</c:forEach>
				</c:if>
			</td>
		</tr>
		</c:forEach>
		</c:if>
	</c:when>

	<c:when test="${viewObj.key eq 'recomendCo' || viewObj.key eq 'oppsCo' || viewObj.key eq 'confmAt'}"><!-- 추천반대 -->
	</c:when>

	<c:otherwise>
		<c:forEach var="viewDtl" items="${viewObj.value}">
		<tr>
			<th>${viewDtl.key }</th>
			<td>${viewDtl.value}</td>
		</tr>
		</c:forEach>
	</c:otherwise>
</c:choose>
</c:forEach>