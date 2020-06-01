<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<c:if test="${bbsSettingVO.reportAt eq 'Y'}">
<script type="text/javascript">
	function f_report_view(bbsNo, nttNo){
		$.ajax({
			type : "post",
			url: '/admin/ajax/board/getReportList.json',
			data :  {
				  "bbsNo" : bbsNo
				, "nttNo" : nttNo
			}
			, dataType : "json"
			, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
			, async : false
			, success: function(data) {
				var reListHtml = f_getBbsListHtml(data.reportList);
				$("#reportListOutput").html(reListHtml);
				$('#list-report-config').modal('show');
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});
	}
	function f_getBbsListHtml(list){
		var returnHtml = "";
		var itemHtml = "";

		$('#reportListOutput').empty();

		itemHtml += '<tr>';
		itemHtml += '	<th class="control-label" style="text-align: center;">번호</th>';
		itemHtml += '	<th class="control-label" style="text-align: center;">신고내용</th>';
		itemHtml += '	<th class="control-label" style="text-align: center;">신고일자</th>';
		itemHtml += '</tr>';

		if(list.length > 0) {
			$.each(list, function(idx, item) {
				itemHtml += '<tr>';
				itemHtml += '	<td class="control-label">'+(idx+1)+'</td>';
				if(item.reportTy == "REPORT_3"){
					itemHtml += '	<td class="control-label">[기타] '+item.cn+'</td>';
				}else{
					itemHtml += '	<td class="control-label">'+item.codeNm+'</td>';
				}
				itemHtml += '	<td class="control-label">'+item.reportDttm+'</td>';
				itemHtml += '</tr>';
			});
		} else {
			itemHtml += '<tr>';
			itemHtml += '	<td class="control-label" style="text-align: center;" colspan="3">조회된 내용이 없습니다.</td>';
			itemHtml += '</tr>';
		}

		returnHtml += itemHtml;

		return returnHtml;
	}
	function f_cancel(){
		$('#list-report-config').modal('toggle');
	}
	</script>
	<style type="text/css" >
		.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
			z-index:999;
		    position: fixed;
		    left:0;
		    right:0;
		    top:0;
		    bottom:0;
		    display:none;
		    background: rgba(0,0,0,0.2); /*not in ie */
		    filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
		}
	    .wrap-loading div{ /*로딩 이미지*/
	    	z-index:999;
	        position: fixed;
	        top:50%;
	        left:50%;
	        margin-left: -21px;
	        margin-top: -21px;
	    }

			.table th{vertical-align: middle}
	</style>

	<div class="wrap-loading" id="wrap-loading">
	    <div><img src="${globalAdminAssets}/images/loading.gif" /></div>
	</div>
	<!-- 신고내역 팝업 -->
	<div class="modal fade" id="list-report-config" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="height:500px; width:600px; display: none;">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title">신고 내역</h4>
				</div>
				<div class="modal-body"  style="min-height: 365px;">
					<table class="table table-bordered table-hover mb-none">
					<colgroup>
						<col width="10%"/>
						<col />
						<col width="20%"/>
					</colgroup>
					<tbody id="reportListOutput">
						<tr>
							<th class="control-label">번호</th>
							<th class="control-label">신고내용</th>
							<th class="control-label">신고일자</th>
						</tr>
						<tr>
							<td class="control-label"></td>
							<td class="control-label"></td>
							<td class="control-label"></td>
						</tr>
					</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" onclick="javascript:f_cancel();">닫기</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
</c:if>