<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<div class="panel-body">
	<div class="featured-box featured-box-primary align-left mt-xlg">
		<div class="box-content shop">
			<h4 class="heading-primary text-uppercase mb-md">관련글</h4>
			<table class="cart-totals" style="width: 100%;">
				<colgroup>
					<col style="width:200px" />
					<col  />
				</colgroup>
				<tbody>
				<c:forEach var="nearList" items="${nearNttMap.relatedList }" varStatus="status">
					<tr>
						<td>${status.count}</td>
						<td class="sib-lst-type-basic-subject" style="padding-top:5px;padding-bottom: 5px;"><a href="${nearList.nttNo}" target="_blank">${nearList.sj }</a></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>