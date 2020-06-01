<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

<!-- INDEX - Vendor CSS -->
<link rel="stylesheet" href="${themeAssets}/vendor/nivo-slider/nivo-slider.css" media="screen">
<link rel="stylesheet" href="${themeAssets}/vendor/nivo-slider/default/default.css" media="screen">



			<div class="row">
				<div class="col-md-12">
					<div class="nivo-slider">
						<div class="slider-wrapper theme-default">
							<div id="nivoSlider" class="nivoSlider">
								<c:import url="/comm/bannerList?bannerCodeId=MAIN&maxLength=10" />
							</div>
							<div id="htmlcaption" class="nivo-html-caption"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="home-intro home-intro-compact">
						<div class="row">
							<div class="col-md-8">
								<p>
									윤커뮤니케이션 <em>R&D Center</em> 입니다..
									<span>샘플용 사이트 입니다.</span>
								</p>
							</div>
							<div class="col-md-4">
								<div class="get-started">
									<a href="#" class="btn btn-lg btn-primary">함께해요!</a>
<!-- 									<div class="learn-more">or <a href="index.html">learn more.</a></div> -->
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>


			<div class="row">
				<h4 class="mb-none">CMS Documents</h4>
				<hr class="solid mt-md">
				<c:import url="/comm/siteMainList?nttCl=SITE_MAIN_1&maxLength=3" />
				<%--
				<div class="col-md-4">
					<div class="recent-posts">
						<article class="post">
							<div class="date">
								<span class="day">15</span>
								<span class="month">Jan</span>
							</div>
							<h4><a href="blog-post.html">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</a></h4>
							<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit vehicula est, in consequat libero. Lorem ipsum amet, consectetur adipiscing elit. Donec hendrerit vehicula est, in consequat libero. <a href="/" class="read-more">read more <i class="fa fa-angle-right"></i></a></p>
						</article>
					</div>
				</div>
				<div class="col-md-4">
					<div class="recent-posts">
						<article class="post">
							<div class="date">
								<span class="day">15</span>
								<span class="month">Jan</span>
							</div>
							<h4><a href="blog-post.html">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</a></h4>
							<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit vehicula est, in consequat.</p>
							<div class="post-meta">
								<span><i class="fa fa-calendar"></i> January 10, 2016 </span>
								<span><i class="fa fa-user"></i> By <a href="#">John Doe</a> </span>
								<span><i class="fa fa-tag"></i> <a href="#">Duis</a>, <a href="#">News</a> </span>
								<span><i class="fa fa-comments"></i> <a href="#">12 Comments</a></span>
								<hr class="solid">
								<a href="blog-post.html" class="btn btn-xs btn-primary pull-right mb-lg">Read more...</a>
							</div>
						</article>
					</div>
				</div>
				<div class="col-md-4">
					<div class="recent-posts">
						<article class="post">
							<div class="owl-carousel owl-theme nav-inside pull-left mr-lg mb-sm" data-plugin-options='{"items": 1, "margin": 10, "animateOut": "fadeOut", "autoplay": true, "autoplayTimeout": 3000}'>
								<div>
									<img alt="" class="img-responsive img-rounded" src="${themeAssets}/img/blog/blog-image-2.jpg">
								</div>
								<div>
									<img alt="" class="img-responsive img-rounded" src="${themeAssets}/img/blog/blog-image-1.jpg">
								</div>
							</div>
							<div class="date">
								<span class="day">15</span>
								<span class="month">Jan</span>
							</div>
							<h4><a href="blog-post.html">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</a></h4>
							<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit vehicula est, in consequat libero. <a href="/" class="read-more">read more <i class="fa fa-angle-right"></i></a></p>
						</article>
					</div>
				</div>
				 --%>
			</div>

			<hr class="tall">

			<div class="row mt-xlg">
				<div class="col-md-12">
						<h4>Recent Posts</h4>
						<div class="owl-carousel owl-theme show-nav-title top-border" data-plugin-options='{"responsive": {"0": {"items": 1}, "479": {"items": 1}, "768": {"items": 2}, "979": {"items": 3}, "1199": {"items": 3}}, "items": 3, "margin": 10, "loop": false, "nav": true, "dots": false}'>
							<c:import url="/comm/cntntsMainList?maxLength=6" />
						</div>


				</div>
			</div>

			<hr class="tall">

			<div class="row">
				<div class="col-md-12">
					<div id="googlemapsFullWidthInside" class="google-map mt-none mb-none" style="height: 280px;"></div>
				</div>
			</div>

<script src="${themeAssets}/vendor/jquery.gmap/jquery.gmap.min.js"></script>
<script src="${themeAssets}/vendor/nivo-slider/jquery.nivo.slider.min.js"></script>
<script src="http://maps.google.com/maps/api/js"></script>



<script>

$(function(){
	if(location.host == 'demo.yooncoms.com'){		
	/*
	Nivo Slider
	*/
	if ($.isFunction($.fn.nivoSlider)) {
		$('#nivoSlider').nivoSlider({
			effect: 'random',
			slices: 15,
			boxCols: 8,
			boxRows: 4,
			animSpeed: 500,
			pauseTime: 3000,
			startSlide: 0,
			directionNav: true,
			controlNav: true,
			controlNavThumbs: false,
			pauseOnHover: true,
			manualAdvance: false,
			prevText: 'Prev',
			nextText: 'Next',
			randomStart: false
		});
	}

	// popup ctrl
	$(function() {
		$(document).on('click', '.popup .btn', function (e) {
			e.preventDefault();
			var action = $(this).data("popupBtnAction");
			var targetId = $(this).data("popupId");
			var exday = 1;
			switch(action){
			case "snooze":
				var exdate = new Date();
				exdate.setDate(exdate.getDate() + exday);
				document.cookie = "popup_ctrl_"+targetId+"=N; expires="+exdate.toUTCString()+"; path=/";
			case "close":
				$("#popup-"+targetId).remove();
				break;
			}
		});
	});

	$("#googlemapsFullWidthInside").gMap({
		controls: {
			draggable: (($.browser.mobile) ? false : true),
			panControl: true,
			zoomControl: true,
			mapTypeControl: true,
			scaleControl: true,
			streetViewControl: true,
			overviewMapControl: true
		},
		scrollwheel: false,
		latitude: 37.396748,
		longitude: 126.969928,
		zoom: 17,
		markers: [
					{
					html: "yooncomunications",
					latitude: 37.396748,
					longitude: 126.969928,
					popup: true,
					icon: {
						image: "${themeAssets}/img/pin.png",
						iconsize: [26, 46],
						iconanchor: [12,46]
						}
					}
				],
	});
	}
});
</script>