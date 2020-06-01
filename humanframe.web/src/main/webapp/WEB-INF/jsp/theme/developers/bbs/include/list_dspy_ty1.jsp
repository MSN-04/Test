<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
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

			<c:when test="${ item.key eq 'thumb' }">
				<c:if test="${item.value != 0 }">
				<img src="/comm/getImage?srvcId=BBSTY1&amp;upperNo=${mapHide.nttNo}&amp;fileTy=THUMBNAIL&amp;fileNo=${item.value}&amp;thumbTy=S" alt="<spring:message code='ui.thumbnail'/>" />
				</c:if>
			</c:when>

			<c:when test="${ item.key eq 'sj' }">
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

			<c:when test="${ item.key eq 'confmAt' }">
			${ confmTyCode[item.value] }
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

	<!-- 일반 게시물 시작 -->
	<c:if test="${listVO.totalCount == 0 and noticeListVO.totalCount == 0}">
		<tr>
			<td colspan="${fn:length(bbsSettingVO.listText) + 1}" style="height:50px; text-align:center; vertical-align:middle;"><spring:message code='data.value.noData' /></td>
		</tr>
	</c:if>
	<c:forEach items="${listVO.listOutptObject}" var="listOutpt" varStatus="status">
		<c:set var="mapShow" value="${listOutpt.mapShow}"/>
		<c:set var="mapHide" value="${listOutpt.mapHide}"/>
		<tr>
			<c:forEach var="item" items="${mapShow}">
				<td>
				<c:choose>
					<c:when test="${ item.key eq 'no' }">
					<c:set var="listNum" value="${listVO.totalCount - ((listVO.curPage - 1) * listVO.cntPerPage) - status.count + 1}"/>
					${listNum}
					</c:when>

					<c:when test="${ item.key eq 'thumb' }">
					<c:if test="${item.value != 0 }">
						<img src="/comm/getImage?srvcId=BBSTY1&amp;upperNo=${mapHide.nttNo}&amp;fileTy=THUMBNAIL&amp;fileNo=${item.value}&amp;thumbTy=S" alt="<spring:message code='ui.thumbnail'/>" />
					</c:if>
					</c:when>

					<c:when test="${ item.key eq 'sj' }">

					<c:set var="hrefValue" value="${currUri}/${mapHide.nttNo}"/>
					<c:choose>
						<c:when test="${mapHide.secretAt eq 'Y' or mapShow.secretAt eq 'Y'}">
							<a href="#" onclick="f_showPasswordDialog('${hrefValue}', '${mapHide.bbsNo}', '${mapHide.nttNo}'); return false;">
						</c:when>
						<c:otherwise>
							<a href="${hrefValue}">
						</c:otherwise>
					</c:choose>

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
					<c:if test="${mapHide.secretAt eq 'Y'}"><i class="fa fa-lock"></i></c:if>
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

					<c:when test="${ item.key eq 'confmAt' }">
					${ confmTyCode[item.value] }
					</c:when>

					<c:when test="${ item.key eq 'wrter' and item.value ne null and item.value ne '' }">
						<c:if test="${mapHide.secretAt eq 'Y' or mapShow.secretAt eq 'Y' or bbsSettingVO.wrterIndict eq 'N'}">${fn:substring(item.value, 0, 1)}<c:forEach begin="0" end="${fn:length(item.value)-2}">*</c:forEach></c:if>
						<c:if test="${mapHide.secretAt eq 'N' or mapShow.secretAt eq 'N'}">${item.value}</c:if>
					</c:when>

					<c:otherwise>
					${item.value}
					</c:otherwise>
				</c:choose>
				</td>
			</c:forEach>
		</tr>
	</c:forEach>
	<!-- 일반 게시물 끝 -->
</tbody>
</table>