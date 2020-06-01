<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
    <script type="text/javascript">
		function searchTag(ht) {
			var url = "//developers.yooncoms.com/comm/hashTagList?tag="+encodeURIComponent(ht);
			location.href=url;
		}
	</script>

	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">[${param.tag }] 검색 (총 ${listVO.totalCount}건)</h2>
		</header>
		<div class="panel-body">
					<c:choose>
					<c:when test="${not empty listVO.listObject}">
					<c:forEach items="${listVO.listObject}" var="listOutpt" varStatus="status">
					<c:set var="listNum" value="${listVO.totalCount - ((listVO.curPage - 1) * listVO.cntPerPage) - status.count + 1}"/>
					<div class="item-board-content">
						<h2><a href="${listOutpt.linkurl }" target="_blank">${listOutpt.title_str }</a></h2>
						<p class="info">
							<span class="date">${listOutpt.date_ymd }</span>
							${fn:replace(listOutpt.sub_ctgr_nm, "/", " > ")}
						</p>
						<div class="cont">
							${listOutpt.content_str }
						</div>
						<dl>
							<dt><span class="hd-element">tag</span></dt>
							<dd>
							<c:if test="${not empty listOutpt.etc2}">
								<c:forEach items="${fn:split(listOutpt.etc2, ',')}" var="hashTag">
									<c:set var="hashTagValue" value="${fn:trim(fn:replace(hashTag,'#','')) }" />
									<a href="#" onclick="searchTag('${fn:trim(hashTagValue)}');">${fn:trim(hashTagValue)}</a>&nbsp;&nbsp;
								</c:forEach>
							</c:if>
							</dd>
						</dl>
					</div>
					</c:forEach>
					</c:when>
					<c:otherwise>
						<div>검색 결과가 없습니다.</div>
					</c:otherwise>
					</c:choose>
				</tbody>
		</div>
		<footer class="panel-footer">
			<div class="row">
				<div class="col-md-12 text-left">
				<cms:paging listVO="${listVO}" />
				</div>
			</div>
		</footer>
	</section>