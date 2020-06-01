<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%-- <script src="${globalAdminAssets}/vendor/flot/jquery.min.js"></script> --%>
<script src="${globalAdminAssets}/vendor/jquery-ui/jquery-ui.js"></script>

	<style type="text/css">
	.ui-sortable { list-style-type: none; margin: 0; padding: 0; width: 100%; }
	.ui-sortable li { margin: 1px; padding: 1px; border: 1px solid #cccccc; color: #0088cc; background: #eeeeee; }
	.ui-sortable li span { position: absolute; margin-left: -1.3em; }
	.ui-sortable li input { padding:0; font-size:12px; height:18px; }
	</style>

	<script type="text/javascript">
	$(document).ready(function(){
		$( "#ulQestn" ).sortable();
	});
	</script>

	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions"  style="position: absolute;">
				<button class="btn btn-default" title="닫기" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">질문 순서 변경</h2>
		</header>

		<form name="frmQestnSort" id="frmQestnSort" method="post" action="./qestnSortAction">
			<div class="panel-body">
				<div class="modal-body" id="listOutptArea"><i class="fa fa-info-circle"></i> 질문을 위 아래로 드래그 해서 순서를 변경해주세요.
					<ul id="ulQestn" class="ui-sortable">
					<c:forEach items="${listQestn}" var="list" varStatus="status">
						<li>${list.qestnText}
							<input type="hidden" name="qestnNo" value="${list.qestnNo}" />
							<input type="hidden" name="ordr" value="${list.ordr}" />
						</li>
					</c:forEach>
					</ul>
				</div>
			</div>

			<div class="panel-footer">
				<div class="row">
					<div class="col-sm-12  text-right">
						<button type="submit" class="btn btn-primary">저장</button>
					</div>
				</div>
			</div>

		</form>
	</section>
