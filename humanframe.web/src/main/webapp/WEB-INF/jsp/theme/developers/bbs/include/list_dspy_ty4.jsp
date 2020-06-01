<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%-- 
<table class="table table-bordered table-striped mb-none" id="datatable-default">
<colgroup>
	<c:forEach var="colHeader" items="${bbsSettingVO.listVal}">
	<c:choose>
		<c:when test="${colHeader eq 'sj'}"><col/></c:when>
		<c:when test="${colHeader eq 'no'}"><col style="width:60px;" /></c:when>
		<c:otherwise><col style="width:100px;" /></c:otherwise>
	</c:choose>
	</c:forEach>
</colgroup>
<thead>
	<tr>
		<c:forEach var="listHeader" items="${bbsSettingVO.listText}">
		<th>${listHeader}</th>
		</c:forEach>
	</tr>
</thead>
<tbody>
	<!-- 공지사항 게시물 시작 -->
	<c:forEach items="${noticeListVO.listOutptObject}" var="listOutpt" varStatus="status">
		<c:set var="mapShow" value="${listOutpt.mapShow}"/>
		<c:set var="mapHide" value="${listOutpt.mapHide}"/>
		<tr>
		<c:forEach var="item" items="${mapShow}">
			<td>
			<c:choose>

			<c:when test="${ item.key eq 'no' }">
			<img src="${themeAssets}/img/icon/icon_notice.gif" alt="<spring:message code='board.notice' />" style="margin-right: 5px;"/>
			</c:when>

			<c:when test="${ item.key eq 'sj' }">
			<c:if test="${!bbsSettingVO.listVal.contains('no')}"><img src="${themeAssets}/img/icon/icon_notice.gif" alt="<spring:message code='board.notice' />" style="margin-right: 5px;"/></c:if>
			<a href="${currUri}/${mapHide.nttNo}">

			<!-- 인기게시물 -->
			<c:choose>
				<c:when test="${bbsSettingVO.popularNttUseAt eq 'Y' and mapShow.rdcnt >= bbsSettingVO.popularNttApplcCo}">
					<font color="${bbsSettingVO.popularNttColor}"><strong>${item.value}</strong></font>
				</c:when>
				<c:otherwise>${item.value}</c:otherwise>
			</c:choose>

			<!-- 신규게시물 -->
			<c:if test="${bbsSettingVO.newNttImageUseAt ne 'N' and mapHide.timeGap <= bbsSettingVO.newNttApplcPd}">
			<c:choose>
				<c:when test="${bbsSettingVO.newNttImageUseAt eq 'D'}">
					<img src='${themeAssets}/img/icon/icon_new.png' alt='<spring:message code='board.new.ntt' />' style="width:30px; height: 15px;"/>
				</c:when>
				<c:when test="${bbsSettingVO.newNttImageUseAt eq 'Y'}">
					<c:set var="nttImgFile" value="${bbsSettingVO.nttNewImgFileList[0]}" />
					<img src='/comm/getImage?srvcId=${nttImgFile.srvcId }&amp;upperNo=${nttImgFile.upperNo }&amp;fileTy=${nttImgFile.fileTy }&amp;fileNo=${nttImgFile.fileNo }'
							alt='<spring:message code='board.new.ntt' />' style="width:30px; height: 15px;"/>
				</c:when>
			</c:choose>
			</c:if>
			</a>
			</c:when>

			<c:when test="${ item.key eq 'fileCo' }">
			<c:if test="${ item.value > 0}">
				<img src="${themeAssets}/img/icon/icon_file.gif" alt="<spring:message code='board.attachFile' />" />
			</c:if>
			</c:when>

			<c:when test="${ item.key eq 'writngDe' }">
			${ cmsFn:convertDate(item.value, 'yyyy.MM.dd') }
			</c:when>

			<c:when test="${ item.key eq 'secretAt' }">
			${ secretTyCode[item.value] }
			</c:when>

			<c:otherwise>
			${item.value}
			</c:otherwise>

			</c:choose>
			</td>
		</c:forEach>
	</tr>
	</c:forEach>
	<!-- 공지사항 게시물 끝 -->
</tbody>
</table>
 --%>
<div class="row mt-xlg">
	<c:forEach items="${listVO.listObject}" var="videoList" varStatus="status">
	<div class="col-md-4">
		<a href="${currUri}/${videoList.nttNo}">
			<span class="thumb-info thumb-info-centered-info">
				<span class="thumb-info-wrapper">
					<img src="/comm/getImage?srvcId=BBSTY4&amp;upperNo=${videoList.nttNo}&amp;fileTy=THUMBNAIL&amp;fileNo=${videoList.thumbFileNo}&amp;thumbTy=M" alt="${videoList.sj} <spring:message code='ui.thumbnail' />" />
					<span class="thumb-info-title">
						<span class="thumb-info-inner">${videoList.sj} <em>${videoList.writngDe}</em></span>
						<!-- <span class="thumb-info-type">Project Type</span> -->
					</span>
					<span class="thumb-info-action">
						<span class="thumb-info-action-icon"><i class="fa fa-link"></i></span>
					</span>
				</span>
			</span>
		</a>
	</div>
	</c:forEach>
</div>