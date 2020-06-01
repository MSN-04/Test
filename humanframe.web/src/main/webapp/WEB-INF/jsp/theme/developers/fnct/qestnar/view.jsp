<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script type="text/javascript">

	var $frm = null;
	function f_submit() {
		if ($frm.length > 0) {
			$frm.submit();
		}
	}

	//결과보기
	function f_viewResult(mode){
		if( mode=="R" ){
			$("#trContent").hide();
			$("#trResult").show();
			$(".viewResult").attr("onclick","f_viewResult('C');return false;").html("설문 내용보기");
		}else{
			$("#trContent").show();
			$("#trResult").hide();
			$(".viewResult").attr("onclick","f_viewResult('R');return false;").html("설문 결과보기");
		}
	}
	</script>


	<div class="panel-body">
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
								${qestnarVO.sj }
							</td>
						</tr>

						<tr>
							<th>설문기간</th>
							<td>${qestnarVO.bgnDttm} ~ ${qestnarVO.endDttm}</td>
						</tr>

						<tr>
							<th>내용</th>
							<td>
							<c:forEach var="imgFileVO" items="${imgFileList }" varStatus="status">
								<c:if test="${ !empty imgFileVO }">
								<img style="width:100px;" src="/comm/getFile?srvcId=${imgFileVO.srvcId }&amp;upperNo=${imgFileVO.upperNo }&amp;fileTy=${imgFileVO.fileTy }&amp;fileNo=${imgFileVO.fileNo }" alt="첨부이미지"/>
							</c:if>
							</c:forEach>
							<br />
							${qestnarVO.cn }
							</td>
						</tr>
						<c:if test="${ qestnarVO.progrsSttus eq 'ING' || qestnarVO.progrsSttus eq 'END' }">
						<tr id="trResult" style="display:none;">
							<th>설문결과</th>
							<td>
							<c:set var="arCircleNo" value="${ fn:split('①,②,③,④,⑤,⑥,⑦,⑧,⑨,⑩,⑪,⑫,⑬,⑭,⑮', ',') }" />
								<c:set var="oldQestnNo" value="0"/>
								<c:set var="listNum" value="0"/>
								<c:set var="listQesitmNo" value="1"/>
								<c:forEach var="qestn" items="${listQesitm}" varStatus="status">
									<c:if test="${ oldQestnNo ne qestn.qestnNo }">
										<c:set var="listNum" value="${listNum+1}"/>
										<c:set var="listQesitmNo" value="1"/>
										<c:if test="${status.index>0 }">
											</ol><!-- 질문별 항목 end -->
										</li><!-- 질문 end -->
										</c:if>
										<li class="boxStyle"><strong>${listNum}. ${qestn.qestnText}</strong>
											<ol>
									</c:if>

									<li>
										<c:out value="${ (listQesitmNo<16) ? arCircleNo[listQesitmNo-1] : listQesitmNo }" /> ${qestn.qesitmText}
										<div class="graph-wrap"><span class="graph-bar" style="width:${qestn.qesitmPercent}%"></span><span class="graph-text">${qestn.qesitmPercent}%</span></div>
									</li>

									<c:set var="oldQestnNo" value="${qestn.qestnNo}" />
									<c:set var="listQesitmNo" value="${listQesitmNo+1}" />

									<c:if test="${status.last}">
										</ol><!-- 질문별 항목 end -->
									</li><!-- 질문 end -->
									</c:if>
								</c:forEach>
							</td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>

		<div class="featured-box featured-box-primary align-left mt-xlg">
			<div class="box-content shop">

				<table class="cart-totals" style="width: 100%;">
					<colgroup>
						<col style="width:200px" />
						<col  />
					</colgroup>
					<tbody>
						<c:set var="prevQestnarNo" value="0" /> <c:set var="prevSj" value="" /> <c:set var="nextQestnarNo" value="0" /> <c:set var="nextSj" value="" />
						<c:forEach var="item" items="${listPrevNext}">
							<c:if test="${item.bigo eq 'PREV' }">
							<c:set var="prevQestnarNo" value="${item.qestnarNo}" />
							<c:set var="prevSj" value="${item.sj }" />
							</c:if>
							<c:if test="${item.bigo eq 'NEXT' }">
							<c:set var="nextQestnarNo" value="${item.qestnarNo}" />
							<c:set var="nextSj" value="${item.sj }" />
							</c:if>
						</c:forEach>
						<tr class="pagerNext">
							<th>다음글</th>
							<td class="subject"><c:if test="${nextQestnarNo == 0 }">다음글이 없습니다.</c:if>
								<c:if test="${nextQestnarNo > 0 }"><a href="${baseUri}/${curMenuVO.menuUri}/view?srchSttus=${param.srchSttus}&amp;qestnarNo=${nextQestnarNo }"><c:out value="${nextSj }"/></a></c:if>
							</td>
						</tr>
						<tr class="pagerPrev">
							<th>이전글</th>
							<td class="subject"><c:if test="${prevQestnarNo == 0 }">이전글이 없습니다.</c:if>
								<c:if test="${prevQestnarNo > 0 }"><a href="${baseUri}/${curMenuVO.menuUri}/view?srchSttus=${param.srchSttus}&amp;qestnarNo=${prevQestnarNo }"><c:out value="${prevSj }"/></a></c:if>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<div class="col-md-6" style="float: right; text-align: right;">
			<p>
				<a href="./list?srchSttus=${param.srchSttus}" class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.list' />"><spring:message code='button.list' /></a>
				<c:if test="${qestnarVO.progrsSttus eq 'ING' }">
				<a href="./privacy?qestnarNo=${param.qestnarNo}" class="btn btn-primary mr-xs mb-sm">설문 참여하기</a>
				</c:if>
				<c:if test="${complete == 'OK'}">
				<a href="#none" class="btn btn-secondary mr-xs mb-sm" onclick="f_viewResult('R');return false;">설문 결과보기</a>
				</c:if>
			</p>
		</div>
	</div>

