// Start danger counter
var length = $('.sidebar-block__item--controls.danger, .sidebar-block__item--sensors.danger').length;
	$('.sidebar-block__item--general .count').prepend(length);

$('.select-device').selectpicker();



// Start switchers
$('.button--setting-general').click(function(event){
  $('.row [class*="block--disable"]').toggleClass('disable');
  $('.main-block--main-content').hide(5);
  $('.main-block--setting-general').show(5);
});

$('.button--setting-user').click(function(event){
  $('.row [class*="block--disable"]').toggleClass('disable');
  $('.main-block--main-content').hide(5);
  $('.main-block--setting-user').show(5);
});

$('.button--setting-security').click(function(event){
  $('.row [class*="block--disable"]').toggleClass('disable');
  $('.main-block--main-content').hide(5);
});



$('.button--back').click(function(event){
	$('.row [class*="block--disable"]').toggleClass('disable');
	$('.main-block--main-content').show(5);
	$('.main-block--setting-general').hide(5);
	$('.main-block--setting-user').hide(5);
});
// End switcher



// Start hide/show phones/emails-inputs
$('.button--add-phone').click(function(event){
	$('.block-setting__content-phones .disable:eq(0)').show(5);
	$('.block-setting__content-phones .disable:eq(0)').removeClass('disable');
});

$('.del-phone').click(function(event){
	$(this).parent().hide(5);
	$(this).parent().addClass('disable');
});



$('.button--add-email').click(function(event){
	$('.block-setting__content-emails .disable:eq(0)').show(5);
	$('.block-setting__content-emails .disable:eq(0)').removeClass('disable');
});

$('.del-email').click(function(event){
	$(this).parent().hide(5);
	$(this).parent().addClass('disable');
});
// End hide/show phones/emails-inputs



// Start hide/show "Специальные настройки"
$('.showHide-switch').click(function() {     
    if($('.block-setting__content-special:visible').length)
        $('.block-setting__content-special').hide(5);
    else
        $('.block-setting__content-special').show(5);        
});
// End show "Специальные настройки"



// Start show "Изменить пароль для входа в кабинет"
$('.button--edit-pwd, .button--edit-pwd-small').click(function() {     
    if($('.block-setting__content--password:visible').length)
        $('.block-setting__content--password').hide(5);
    else
        $('.block-setting__content--password').show(5);        
});
// End show "Изменить пароль для входа в кабинет"



// Start show "Добавить систему"
$('.button--add-system').click(function() {     
    if($('.block-setting__content--add-system:visible').length)
        $('.block-setting__content--add-system').hide(5);
    else
        $('.block-setting__content--add-system').show(5);        
});
// End show "Добавить систему"



// Start hide/show for LoginPage
$('.link--recovery').click(function(event){
  $('.row.recovery-form-block').show(5);
  $('.row.login-form-block').hide(5);
});
$('.recovery-form .link--back').click(function(event){
  $('.row.recovery-form-block').hide(5);
  $('.row.login-form-block').show(5);
});



$('.link--registration').click(function(event){
  $('.row.registration-form-block').show(5);
  $('.row.login-form-block').hide(5);
});
$('.registration-form .link--back').click(function(event){
  $('.row.registration-form-block').hide(5);
  $('.row.login-form-block').show(5);
});
// End hide/show for LoginPage



// Start hide/show for control-page--add
$('.control-block__item--control').click(function(event){
  $('.control-block__item--control.checked').toggleClass('checked');
  $('.control-block__content .disable').show(5);
  $(this).toggleClass('checked');
});



$('.control-block__item--default').click(function(event){
  $('.control-block__item--control.checked').toggleClass('checked');
  $('.control-block__content .disable').show(5);
  $(this).toggleClass('checked');
});
// End hide/show for control-page--add


$('#ex12c').slider({ 
	tooltip: 'always',
  tooltip_split: true,
	id: 'slider12c', 
	min: -1, 
	max: 100, 
	range: true, 
	value: [55, 75],
    ticks: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
    ticks_labels: ['0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'],
    ticks_snap_bounds: 30
});

$('#ex9').slider({ precision: 2 });
$('#ex10').slider({ precision: 2 });
