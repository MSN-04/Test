<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ page trimDirectiveWhitespaces="true" %>
		
	<sql:setDataSource dataSource="jdbc/cmsdb"	var="ds" scope="session" />
	
	<sql:query var="rs" dataSource="${ds }">
		SELECT (SELECT detail FROM tn_cm_respond_answer WHERE answer = tcr.respond_answer AND menu_no = tc.menu_no) AS gift_name
		     , COUNT(1) AS cnt
		  FROM tn_cm tc
		  LEFT OUTER JOIN tn_cm_respond tcr
		    ON tc.cm_no = tcr.cm_no
		 WHERE tc.menu_no = '${curMenuVO.menuNo}'
		   AND tc.delete_at = 'N'
		 GROUP BY tcr.respond_answer
		 ORDER BY cnt desc
	</sql:query>
	
	<div class="post-block post-leave-comment">
		<h3 class="heading-primary"><i class="fa fa-question-circle"></i>다른 사람들은 무엇을 골랐을까?</h3>

		<table class="table table-hover mt-md">
			<thead>
				<tr>
					<th>선물세트</th>
					<th>선택</th>
				</tr>
			</thead>
			<tbody>
				<c:set var="totalCnt" value="0" />
				<c:forEach var="row" items="${rs.rowsByIndex }">
				<tr>
					<th>${row[0]}</th>
					<td>${row[1]}</td>
				</tr>
				<c:set var="totalCnt" value="${totalCnt + row[1]}"/>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<th></th>
					<th>${totalCnt }</th>
				</tr>
			</tfoot>
		</table>
	</div>
	
	