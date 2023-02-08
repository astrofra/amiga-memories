g_size_font_title 				<- 32
g_size_font_modificator 	<- 32
g_size_font_text 					<- 26

g_size_font_color_title 			<- 0xffff00ff
g_size_font_color_modificator <- 0xffff00ff
g_size_font_color_text 				<- 0xffffffff

g_skin	<- {
default_skin 	= { left_picture="ui/default_background_ui_left_part.png", 
					middle_picture="ui/default_background_ui_middle_part.png", 
					right_picture="ui/default_background_ui_right_part.png", 
					slider_cursor="ui/default_arrow_down_slider.tga", 
					next_picture="ui/arrow_right.tga", 
					prev_picture="ui/arrow_left.tga", 
					check_picture="ui/icon_check_true.tga" , 
					uncheck_picture="ui/icon_check_false.tga", 
					vertical_scroll_picture="ui/list_scrollbar.tga", 
					sound_active="ui/icon_sound_active.tga", 
					sound_unactive="ui/icon_sound_unactive.tga",
					unzoom="ui/icon_unzoom.tga",
					zoom="ui/icon_zoom.tga",
					play="ui/icon_vcr_play.tga",
					pause="ui/icon_vcr_pause.tga",
					play_slow="ui/icon_vcr_play_slow.tga",
					play_step_backward="ui/icon_vcr_step_backward.tga",
					play_step_forward="ui/icon_vcr_step_forward.tga",
					weather_sun_checked="ui/icon_weather_sun_true.tga",
					weather_sun_unchecked="ui/icon_weather_sun_false.tga",
					weather_rain_checked="ui/icon_weather_rain_true.tga",
					weather_rain_unchecked="ui/icon_weather_rain_false.tga",
					weather_snow_checked="ui/icon_weather_snow_true.tga",
					weather_snow_unchecked="ui/icon_weather_snow_false.tga",
					weather_fog_checked="ui/icon_weather_fog_true.tga",
					weather_fog_unchecked="ui/icon_weather_fog_false.tga"},

avengers_skin = {	left_picture="ui/background_ui_left_part.png", 
					middle_picture="ui/background_ui_middle_part.png", 
					right_picture="ui/background_ui_right_part.png", 
					slider_cursor="ui/arrow_down_slider.png", 
					next_picture="ui/arrow_right.tga", 
					prev_picture="ui/arrow_left.tga", 
					check_picture="ui/icon_check_true.tga" , 
					uncheck_picture="ui/icon_check_false.tga", 
					vertical_scroll_picture="ui/list_scrollbar.tga", 
					sound_active="ui/icon_sound_active.tga", 
					sound_unactive="ui/icon_sound_unactive.tga",
					unzoom="ui/icon_unzoom.tga",
					zoom="ui/icon_zoom.tga",
					play="ui/icon_vcr_play.tga",
					pause="ui/icon_vcr_pause.tga",
					play_slow="ui/icon_vcr_play_slow.tga",
					play_step_backward="ui/icon_vcr_step_backward.tga",
					play_step_forward="ui/icon_vcr_step_forward.tga",
					weather_sun_checked="ui/icon_weather_sun_true.tga",
					weather_sun_unchecked="ui/icon_weather_sun_false.tga",
					weather_rain_checked="ui/icon_weather_rain_true.tga",
					weather_rain_unchecked="ui/icon_weather_rain_false.tga",
					weather_snow_checked="ui/icon_weather_snow_true.tga",
					weather_snow_unchecked="ui/icon_weather_snow_false.tga",
					weather_fog_checked="ui/icon_weather_fog_true.tga",
					weather_fog_unchecked="ui/icon_weather_fog_false.tga"},

orange_skin		= {},
}

//	Orange Skin
g_skin.orange_skin = clone(g_skin.default_skin)
g_skin.orange_skin.left_picture="ui/orange_background_ui_left_part.png"
g_skin.orange_skin.middle_picture="ui/orange_background_ui_middle_part.png"
g_skin.orange_skin.right_picture="ui/orange_background_ui_right_part.png"

g_hover_animation	<- [
	"no_animation", "expand"
]

g_alignment	<-	[
	"left", "center", "right"
]