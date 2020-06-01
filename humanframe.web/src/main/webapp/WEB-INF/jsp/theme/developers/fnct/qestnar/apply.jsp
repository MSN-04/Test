<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script type="text/javascript">
	function f_save(){
		var $etcObj = null;
		var result = true;

		<c:set var="oldQestnNo" value="0"/>
		<c:set var="listNum" value="0"/>
		<c:forEach var="qestn" items="${listQesitm}" varStatus="status">
			<c:if test="${ oldQestnNo ne qestn.qestnNo }">
				<c:set var="listNum" value="${listNum+1}"/>

				<c:if test="${qestn.essentialTy eq 'Y' }">
					<c:choose>
						<c:when test="${qestn.qestnTy eq 'R'}">
						if( $("input:radio[name='i_${qestn.qestnNo}']" ).is(":disabled") == false ){
							if( $("input:radio[name='i_${qestn.qestnNo}']" ).is(":checked") == false ){
								alert("${listNum}번째 항목은 필수입니다.");
								$("input:radio[name='i_${qestn.qestnNo}']" ).eq(0).focus();
								return false;
							}else{
								if( $("input:radio[name='i_${qestn.qestnNo}']:checked" ).hasClass("clsEtc") ){
									$etcObj = $("input:radio[name='i_${qestn.qestnNo}']:checked").parent().find(":text");
									if( $.trim($etcObj.val())=="" ){
										alert("<spring:message arguments='기타의견' code='errors.required'/>");
										$etcObj.focus();
										return false;
									}
								}
							}
						}
						</c:when>
						<c:when test="${qestn.qestnTy eq 'C'}">
						if( $("input:checkbox[name='i_${qestn.qestnNo}']:disabled" ).length<=0 ){
							if( $("input:checkbox[name='i_${qestn.qestnNo}']:checked" ).length<=0 ){
								alert("${listNum}번째 항목을 선택해주세요.");
								$("input:checkbox[name='i_${qestn.qestnNo}']" ).eq(0).focus();
								return false;
							}else{
								$("input:checkbox[name='i_${qestn.qestnNo}']:checked" ).each(function(){
									if( $(this).hasClass("clsEtc") ){
										$etcObj =  $(this).parent().find(":text");
										if( $.trim($etcObj.val())=="" ){
											result = false;
											alert("<spring:message arguments='기타의견' code='errors.required'/>");
											$etcObj.focus();
											return;
										}
									}
								});

								if( result==false ){
									return false;
								}
							}
						}
						</c:when>
						<c:otherwise>
						if($("#t_${qestn.qesitmNo}").is(":disabled") == false){
							if( $.trim($("#t_${qestn.qesitmNo}").val()) == "" ){
								alert("<spring:message arguments='주관식' code='errors.required'/>");
								$("#t_${qestn.qesitmNo}").focus();
								return false;
							}
						}
						</c:otherwise>
					</c:choose>
			</c:if>

			</c:if>
			<c:set var="oldQestnNo" value="${qestn.qestnNo}" />

		</c:forEach>

		$("#frmApply").submit();
	}
	function f_nextQestn(nextQestnNo, listNum, qesitmNo){
		var exNextQestnNoArr = new Array();

		if($("#exNextQestnNo" +listNum).val() != ''){
			exNextQestnNoArr = $("#exNextQestnNo" +listNum).val().split(',');
		}

		var nextQestnNoArr = nextQestnNo.split('|');
		for(var i in nextQestnNoArr){
			if($.inArray(nextQestnNoArr[i], exNextQestnNoArr) === -1) exNextQestnNoArr.push(nextQestnNoArr[i]);
		}

		$("#exNextQestnNo" +listNum).val(exNextQestnNoArr);

		for(var i in exNextQestnNoArr){
			// 라디오인경우만 다음질문 선택사항 disable
			if($("input:radio[id='example"+qesitmNo+"']").is(":checked")){
				$("#" + exNextQestnNoArr[i]).children().find(".clsNextQestn").prop("disabled", true);
			}
		}
		for(var i in nextQestnNoArr){
			// 체크박스인경우
			if($("input:checkbox[id='example"+qesitmNo+"']").is(":checked")){
				$("#" + nextQestnNoArr[i]).children().find(".clsNextQestn").prop("disabled", false);
			} else{
				$("#" + nextQestnNoArr[i]).children().find(".clsNextQestn").prop("disabled", true);
			}
			// 라디오박스인경우
			if($("input:radio[id='example"+qesitmNo+"']").is(":checked")){
				$("#" + nextQestnNoArr[i]).children().find(".clsNextQestn").prop("disabled", false);
			}
		}
	}

	$(document).ready(function(){
	    $(':radio').on('change', function(){
	       if( $(this).hasClass("clsEtc") ){
				$(this).parent().find(":text").prop("disabled",false);
			}else{
				$(this).parent().parent().last().find(":text").val("").prop("disabled",true);
			}
	    });

		$(":checkbox, .clsEtc").click(function(){
			if( $(this).is(":checked")==true ){
				$(this).parent().find(":text").prop("disabled",false);
			}else{
				$(this).parent().find(":text").val("").prop("disabled",true);
			}
		});

		$(".clsNextQestn").each(function(index) {
			$(this).prop("disabled",true);
		});

	});
	</script>

	<form name="frmApply" id="frmApply" method="post" enctype="multipart/form-data" action="./action">
	<input type="hidden" name="qestnarNo" id="qestnarNo" value="${qestnarVO.qestnarNo}" />
	<input type="hidden" name="sj" id="sj" value="${qestnarVO.sj}" />
	<input type="hidden" name="retUrl" id="retUrl" value="${baseUri}/${curMenuVO.menuUri}" />
	<input type="hidden" name="nm" id="nm" value="${mapInput.nm}" />
	<input type="hidden" name="email" id="email" value="${mapInput.email}" />
	<input type="hidden" name="telno" id="telno" value="${mapInput.telno}" />
	<input type="hidden" name="address" id="address" value="${mapInput.address}" />
	<input type="hidden" name="crtrUniqueId" id="crtrUniqueId" value="${mapInput.crtrUniqueId }" />
	<input type="hidden" name="dplctCnfirmCode" id="dplctCnfirmCode" value="${mapInput.dplctCnfirmCode }" />

	<div class="panel-body">
		<div class="featured-box featured-box-primary align-left mt-xlg">
			<div class="box-content shop">
				<div class="form-group">
					<h4 class="form-data-subject">${qestnarVO.sj }</h4>
				</div>
				<div class="form-group">
					<dl class="form-data-info">
						<dt><span>설문기간</span></dt>
						<dd>${qestnarVO.bgnDttm} ~ ${qestnarVO.endDttm}</dd>
					</dl>
				</div>
				<div class="form-group">
					<dl style="background-color:#fff" class="form-data-content" id="trContent">
						<dt><span>설문 사항</span></dt>
						<dd style="padding-top:0">
							<ol>
							<c:set var="oldQestnNo" value="0"/>
							<c:set var="listNum" value="0"/>
							<c:forEach var="qestn" items="${listQesitm}" varStatus="status">
								<c:if test="${ oldQestnNo ne qestn.qestnNo }">
									<c:set var="listNum" value="${listNum+1}"/>
									<c:if test="${status.index>0 }">
										</ol><!-- 질문별 항목 end -->
									</li><!-- 질문 end -->
									</c:if>
									<li style="background-color:#fff" class="boxStyle02" id="${listNum}">
										<strong class="title">${listNum}. ${qestn.qestnText}</strong>
										<c:if test="${qestn.essentialTy eq 'Y' }">
											<font color="red">[필수]</font>
										</c:if>
										<c:if test="${qestn.nextQestnTy eq 'Y' }">
											<font color="red">[선택질문]</font>
										</c:if>
										<ol>
								</c:if>

								<li>
									<c:set var="clsEtc" value=""/>
									<%-- <c:if test="${ qestn.etcOpinionAt eq 'Y' and qestn.qesitmText eq '기타의견' }">
										<c:set var="clsEtc" value=' class="clsEtc"' />
									</c:if>
									--%>
									<c:choose>
										<c:when test="${ qestn.etcOpinionAt eq 'Y' and qestn.qesitmText eq '기타의견' }">
											<c:choose>
												<c:when test="${ qestn.nextQestnTy eq 'Y'}">
													<c:set var="clsEtc" value=' class="clsEtc clsNextQestn"' />
												</c:when>
												<c:otherwise>
													<c:set var="clsEtc" value=' class="clsEtc"' />
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<c:if test="${ qestn.nextQestnTy eq 'Y'}">
												<c:set var="clsEtc" value=' class="clsNextQestn"' />
											</c:if>
										</c:otherwise>
									</c:choose>

									<c:set var="clsNextQestnNo" value=""/>
									<c:set var="txtNextQestn" value=""/>
									<c:choose>
										<c:when test="${ oldQestnNo ne qestn.qestnNo }">
											<input type="hidden" id="exNextQestnNo${listNum}">
										</c:when>
									</c:choose>

									<c:set var="clsNextQestnNo" value=' onclick="f_nextQestn(\'${qestn.nextQestnNo}\', ${listNum}, ${qestn.qesitmNo})"' />
									<c:if test="${ qestn.nextQestnAt eq 'Y'}">
										<c:set var="txtNextQestn" value=' (선택시 ${qestn.nextQestnNo}번 질문)'/>
									</c:if>

									<c:choose>
										<c:when test="${ qestn.qestnTy eq 'R' }">
											<input type="radio" name="i_${qestn.qestnNo}" id="example${qestn.qesitmNo}" value="${qestn.qesitmNo}" ${clsEtc} ${clsNextQestnNo}/>
											<label for="example${qestn.qesitmNo}">${qestn.qesitmText} ${txtNextQestn}</label>
										</c:when>
										<c:when test="${ qestn.qestnTy eq 'C' }">
											<input type="checkbox" name="i_${qestn.qestnNo}" id="example${qestn.qesitmNo}" value="${qestn.qesitmNo}" ${clsEtc} ${clsNextQestnNo} />
											<label for="example${qestn.qesitmNo}">${qestn.qesitmText} ${txtNextQestn}</label>
										</c:when>
									<c:otherwise>
										<input type="text" name="t_${qestn.qestnNo}|${qestn.qesitmNo}" id="t_${qestn.qesitmNo}" value="" class="textForm <c:if test="${ qestn.nextQestnTy eq 'Y'}">clsNextQestn</c:if>" style="width:80%;border:1px solid;"/>
									</c:otherwise>
									</c:choose>
									<c:if test="${qestn.fileNo ne null }">
										<br/><label for="example${qestn.qesitmNo}"><img style="margin-left:30px; max-width:30%; max-height:300px;" class="media-object" src="/comm/getFile?srvcId=QESTNARTM&amp;upperNo=${qestn.qesitmNo }&amp;fileTy=${qestn.fileTy }&amp;fileNo=${qestn.fileNo }" alt="${qestn.orginlFileNm}"/></label>
									</c:if>
									<c:if test="${ qestn.etcOpinionAt eq 'Y' and qestn.qesitmText eq '기타의견' }">
										<input type="text" name="e_${qestn.qestnNo}|${qestn.qesitmNo}" id="e_${qestn.qesitmNo}" value=""  class="textForm" style="width:50%;border:1px solid;" disabled="disabled"  ${clsNextQestnNo}/>
									</c:if>
								</li>

								<c:set var="oldQestnNo" value="${qestn.qestnNo}" />

								<c:if test="${status.last}">
									</ol><!-- 질문별 항목 end -->
								</li><!-- 질문 end -->
								</c:if>
							</c:forEach>
							</ol>
						</dd>
					</dl>
				</div>





			</div>
		</div>
	</div>

	<div class="col-md-6" style="float: right; text-align: right;">
		<p>
			<a href="#none" class="btn btn-primary mr-xs mb-sm" onclick="f_save();return false;">등록</a>
			<a href="./view?qestnarNo=${qestnarVO.qestnarNo }&srchSttus=${param.srchSttus }" class="btn btn-secondary mr-xs mb-sm">취소</a>
		</p>
	</div>
	</form>

