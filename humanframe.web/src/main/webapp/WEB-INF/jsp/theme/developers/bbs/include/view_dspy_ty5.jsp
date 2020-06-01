<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<div class="panel-body">
	<form class="form-horizontal form-bordered" method="post">
		<div class="featured-box featured-box-primary align-left mt-xlg">
			<div class="box-content shop">
				<h4 class="heading-primary text-uppercase mb-md"><spring:message code='ui.details' /></h4>
				<table class="cart-totals" style="width: 100%;">
					<colgroup>
						<col style="width:200px" />
						<col  />
					</colgroup>
					<tbody>

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

						<c:when test="${viewObj.key eq 'sttusTy' }"><!-- 처리상태 -->
							<c:forEach var="viewDtl" items="${viewObj.value }">
							<tr>
								<th>${viewDtl.key }</th>
								<td>${sttusTyCode[viewDtl.value]}</td>
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

						<c:when test="${viewObj.key eq 'cclTy' }"><!-- CCL여부 -->
							<c:if test="${bbsSettingVO.cclAt eq 'Y'}">
							<c:forEach var="viewDtl" items="${viewObj.value }">
							<tr>
								<th>${viewDtl.key }</th>
								<td><c:if test="${not empty viewDtl.value}">${licCode[viewDtl.value-1].codeNm}</c:if></td>
							</tr>
							</c:forEach>
							</c:if>
						</c:when>

						<c:when test="${viewObj.key eq 'qestnFileList' }"><!-- 첨부파일 -->
							<c:forEach var="viewDtl" items="${viewObj.value }">
							<tr>
								<th>${viewDtl.key }</th>
								<td>
									<c:forEach var="bbsFileList" items="${bbsTypeVO.qestnFileList}" varStatus="status">
										<a href="/comm/getFile?srvcId=${bbsFileList.srvcId }&amp;upperNo=${bbsFileList.upperNo }&amp;fileTy=${bbsFileList.fileTy }&amp;fileNo=${bbsFileList.fileNo }">
											${bbsFileList.orginlFileNm} (<spring:message code='board.file.size' />: ${cmsFn:fileSize(bbsFileList.fileSize)}, <spring:message code='button.download' /> : ${bbsFileList.dwldCo}<spring:message code='ui.count' />)
										</a><br/>
									</c:forEach>
								</td>
							</tr>
							</c:forEach>
						</c:when>

						<c:when test="${viewObj.key eq 'answerFileList' or viewObj.key eq 'answrr' or viewObj.key eq 'answerDe' or viewObj.key eq 'answer' || viewObj.key eq 'confmAt'}"><!-- 제외 -->
						</c:when>
						
						<c:when test="${viewObj.key eq 'wrter' }">
							<c:forEach var="viewDtl" items="${viewObj.value }">
							<tr>
								<th>${viewDtl.key }</th>
								<td><c:if test="${not empty viewDtl.value and bbsSettingVO.wrterIndict eq 'N'}">${fn:substring(viewDtl.value, 0, 1)}<c:forEach begin="0" end="${fn:length(viewDtl.value)-2}">*</c:forEach></c:if>
								<c:if test="${not empty viewDtl.value and bbsSettingVO.wrterIndict eq 'Y'}">${viewDtl.value}</c:if></td>
							</tr>
							</c:forEach>
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

					</tbody>
				</table>
			</div>
		</div>
	</form>
</div>

<c:if test="${bbsTypeVO.sttusTy eq '2'}">
<div class="panel-body">
	<form class="form-horizontal form-bordered" method="post">
		<div class="featured-box featured-box-primary align-left mt-xlg">
			<div class="box-content shop">
				<h4 class="heading-primary text-uppercase mb-md"><spring:message code='board.answer' /></h4>
				<table class="cart-totals" style="width: 100%;">
					<colgroup>
						<col style="width:200px" />
						<col  />
					</colgroup>
					<tbody>
						<c:forEach var="viewDtl" items="${bbsTypeVO.viewObject['answrr']}">
						<tr>
							<th>${viewDtl.key}</th>
							<td>${viewDtl.value}</td>
						</tr>
						</c:forEach>
						<c:forEach var="viewDtl" items="${bbsTypeVO.viewObject['answerDe']}">
						<tr>
							<th>${viewDtl.key}</th>
							<td>${viewDtl.value}</td>
						</tr>
						</c:forEach>
						<c:forEach var="viewDtl" items="${bbsTypeVO.viewObject['answer']}">
						<tr>
							<th>${viewDtl.key}</th>
							<td>${viewDtl.value}</td>
						</tr>
						</c:forEach>
						<c:forEach var="viewDtl" items="${bbsTypeVO.viewObject['answerFileList']}">
						<tr>
							<th>${viewDtl.key}</th>
							<td>
								<c:forEach var="bbsFileList" items="${bbsTypeVO.answerFileList}" varStatus="status">
									<a href="/comm/getFile?srvcId=${bbsFileList.srvcId }&amp;upperNo=${bbsFileList.upperNo }&amp;fileTy=${bbsFileList.fileTy }&amp;fileNo=${bbsFileList.fileNo }">
										${bbsFileList.orginlFileNm} (<spring:message code='board.file.size' />: ${cmsFn:fileSize(bbsFileList.fileSize)}, <spring:message code='button.download' /> : ${bbsFileList.dwldCo}<spring:message code='ui.count' />)
									</a><br/>
								</c:forEach>
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</form>
</div>
</c:if>