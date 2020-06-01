<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="메타데이터"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">메타데이터 상세조회</h2>
					</header>
					<div class="panel-body">

						<div class="table-responsive">

							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:100" />
									<col style="width:150" />
									<col style="width:100" />
									<col style="width:150" />
									<col style="width:100" />
									<col />
								</colgroup>
								<tr>
									<th>표제</th>
									<td colspan="5">${metadataVO.dcTitle}</td>
								</tr>
								<tr>
									<th>주제</th>
									<td colspan="5">${metadataVO.dcSubject}</td>
								</tr>
								<tr>
									<th>식별자</th>
									<td colspan="5">${metadataVO.dcIdentifier}</td>
								</tr>
								<tr>
									<th>언어</th>
									<td colspan="5">${metadataVO.dcLanguage}</td>
								</tr>
								<tr>
									<th>자료유형</th>
									<td>${metaTyCode[metadataVO.dcType]}</td>
									<th>파일형식</th>
									<td>${metadataVO.dcFormat}</td>
									<th>자원크기</th>
									<td>${metadataVO.dcFormatExtent}</td>
								</tr>
								<tr>
									<th>범위</th>
									<td colspan="5">
										<table class="table table-bordered mb-none">
											<colgroup>
												<col style="width:100px"/>
												<col />
											</colgroup>
											<tr>
												<th>공간적 범위</th>
												<td>${metadataVO.dcCoverageSpatial}</td>
											</tr>
											<tr>
												<th>시간적 범위</th>
												<td>${metadataVO.dcCoverageTemporal}</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<th>요약정보</th>
									<td colspan="5">${metadataVO.dcDescription}</td>
								</tr>
								<tr>
									<th>관련자원</th>
									<td colspan="5">${metadataVO.dcRelation}</td>
								</tr>
								<tr>
									<th>날짜</th>
									<td colspan="5">
									<table class="table table-bordered mb-none">
										<colgroup>
											<col style="width:100px"/>
											<col style="width:150px"/>
											<col style="width:100px"/>
											<col />
										</colgroup>
										<!--
										<tr>
											<th>대표일</th>
											<td>${metadataVO.dcDate}</td>
										</tr>
										-->
										<tr>
											<th>이용가능일</th>
											<td>${metadataVO.dcDateAvailable}</td>
											<th>생성일</th>
											<td>${metadataVO.dcDateCreated}</td>
										</tr>
										<tr>
											<th>수정일</th>
											<td>${metadataVO.dcDateModified}</td>
											<th>발행일</th>
											<td>${metadataVO.dcDateIssued}</td>
										</tr>
									</table>
									</td>
								</tr>
								<tr>
									<th>발행정보</th>
									<td colspan="5">
										<table class="table table-bordered mb-none">
											<colgroup>
												<col style="width:100px"/>
												<col />
											</colgroup>
											<tr>
												<th>발행처</th>
												<td>${metadataVO.dcPublisher}</td>
											</tr>
											<tr>
												<th>생성자</th>
												<td>${metadataVO.dcCreator}</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<th>정보원</th>
									<td colspan="5">${metadataVO.dcSource}</td>
								</tr>
								<tr>
									<th>기여자</th>
									<td colspan="5">${metadataVO.dcContributor}</td>
								</tr>
								<tr>
									<th>권한</th>
									<td colspan="5">
										<table class="table table-bordered mb-none">
											<colgroup>
												<col style="width:100px"/>
												<col />
											</colgroup>
											<tr>
												<th>접근권한</th>
												<td>${metadataVO.dcRightAccessright}</td>
											</tr>
											<tr>
												<th>허가증</th>
												<td>${licTyCode[metadataVO.dcRightLicense]}</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>

						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12">

								<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;srchWord=${param.srchWord}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>


							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>
