<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
	<script type="text/javascript">
	</script>

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

							<tr>
								<th>제목</th>
								<td>
									${sampleVO.sj}
								</td>
							</tr>

							<tr>
								<th>작성자</th>
								<td>${sampleVO.crtrNm}</td>
							</tr>

							<tr>
								<th>사용여부</th>
								<td>${useAtCode[sampleVO.useAt]}</td>
							</tr>

							<tr>
								<th>내용</th>
								<td>${sampleVO.cn}</td>
							</tr>


						<tr>
							<th>첨부파일</th>
							<td>
								<c:forEach var="sampleFileList" items="${sampleVO.sampleFileList}" varStatus="status">
									<a href="/comm/getFile?srvcId=${sampleFileList.srvcId }&amp;upperNo=${sampleFileList.upperNo }&amp;fileTy=${sampleFileList.fileTy }&amp;fileNo=${sampleFileList.fileNo }">
										${sampleFileList.orginlFileNm} (<spring:message code='board.file.size' />: ${cmsFn:fileSize(sampleFileList.fileSize)}, <spring:message code='button.download' /> : ${sampleFileList.dwldCo}<spring:message code='ui.count' />)
									</a><br/>
								</c:forEach>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
		</form>
	</div>

	<div class="col-md-6" style="float: right; text-align: right;">
		<p>
			<a href="${baseUri}/${curMenuVO.menuUri}/form?sampleNo=${sampleVO.sampleNo}&amp;sampleNo=${sampleVO.sampleNo}" class="btn btn-primary mr-xs mb-sm" title="<spring:message code='button.update' />"><spring:message code='button.update' /></a>
			<a href="" class="btn btn-secondary mr-xs mb-sm" title="<spring:message code='button.delete' />"><spring:message code='button.delete' /></a>
			<a href="${baseUri}/${curMenuVO.menuUri}" class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.list' />"><spring:message code='button.list' /></a>
		</p>
	</div>