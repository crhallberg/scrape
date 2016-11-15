//void_setblockImages


//block colors!
color[] blockColor = new color[9];

//PImages!!!
PImage[] anyBlock_img = new PImage[0]; //Hmm.
//Motion    - blue
PImage[] motionBlock_img = new PImage[15];
PImage move_X_steps_img;
PImage turn_X_degrees_img;
PImage poPImage_in_direction_X_img;
PImage poPImage_towards_X_img;
PImage go_to_x_X_y_X_img;
PImage go_to_X_img;
PImage glide_X_seconds_to_x_X_y_X_img;
PImage change_x_by_X_img;
PImage set_x_to_X_img;
PImage change_y_by_X_img;
PImage set_y_to_X_img;
PImage if_on_edge_bounce_img;
PImage x_position_img;
PImage y_position_img;
PImage direction_img;

//Control   - yellow-orange
PImage[] controlBlock_img = new PImage[16];
PImage when_green_flag_clicked_img;
PImage when_X_key_pressed_img;
PImage when_X_clicked_img;
PImage wait_X_seconds_img;
PImage forever_img;
PImage repeat_img;
PImage broadcast_img;
PImage broadcast_and_wait_img;
PImage when_I_receive_img;
PImage forever_if_img;
PImage If_img;
PImage if_else_img;
PImage wait_until_img;
PImage repeat_until_img;
PImage stop_script_img;
PImage stop_all_img;

//Looks     - purple
PImage[] looksBlock_img = new PImage[20];
PImage switch_to_background_X_img;
PImage next_background_img;
PImage background_number_img;
PImage switch_to_costume_X_img;
PImage next_costume_img;
PImage costume_number_img;
PImage say_X_for_X_seconds_img;
PImage say_X_img;
PImage think_X_for_X_seconds_img;
PImage think_X_img;
PImage change_X_effect_by_X_img;
PImage set_X_effect_to_X_img;
PImage clear_graphic_effects_img;
PImage change_size_by_X_img;
PImage set_size_to_X_percent_img;
PImage size_img;
PImage show_img;
PImage hide_img;
PImage go_to_front_img;
PImage go_back_X_layers_img;

//Sensing   - teal
PImage[] sensingBlock_img = new PImage[17];
PImage touching_X_img;
PImage touching_color_COLOR_img;
PImage color_COLOR_is_touching_COLOR_img;
PImage ask_X_and_wait_img;
PImage answer_img;
PImage mouse_x_img;
PImage mouse_y_img;
PImage mouse_down_img;
PImage key_X_pressed_img;
PImage distance_to_X_img;
PImage reset_timer_img;
PImage timer_img;
PImage X_of_X_img;
PImage loudness_img;
PImage loud_img;
PImage X_sensor_value_img;
PImage sensor_X_img;

//Sound     - pink
PImage[] soundBlock_img = new PImage[13];
PImage play_sound_X_img;
PImage play_sound_X_until_done_img;
PImage stop_all_sounds_img;
PImage play_drum_X_for_X_beats_img;
PImage rest_for_X_beats_img;
PImage play_note_X_for_X_beats_img;
PImage set_instrument_to_X_img;
PImage change_volume_by_X_img;
PImage set_volume_to_X_percent_img;
PImage volume_img;
PImage change_tempo_by_X_img;
PImage set_tempo_to_X_bpm_img;
PImage tempo_img;

//Operators   - lime green
PImage[] operatorsBlock_img = new PImage[28];
PImage plus_img;
PImage minus_img;
PImage multiply_img;
PImage divide_img;
PImage pick_random_X_to_X_img;
PImage less_than_img;
PImage equals_img;
PImage greater_than_img;
PImage and_img;
PImage or_img;
PImage not_img;
PImage join_X_X_img;
PImage letter_X_of_X_img;
PImage length_of_X_img;
PImage mod_img;
PImage round_img;
PImage abs_img;
PImage sqrt_img;
PImage sin_img;
PImage cos_img;
PImage tan_img;
PImage asin_img;
PImage acos_img;
PImage atan_img;
PImage ln_img;
PImage log_img;
PImage e_to_the_power_img;
PImage ten_to_the_power_img;

//Pen       - hunter green
PImage[] penBlock_img = new PImage[11];
PImage clear_img;
PImage pen_down_img;
PImage pen_up_img;
PImage set_pen_color_to_COLOR_img;
PImage change_pen_color_by_X_img;
PImage set_pen_color_to_X_img;
PImage change_pen_shade_by_X_img;
PImage set_pen_shade_to_X_img;
PImage change_pen_size_by_X_img;
PImage set_pen_size_to_X_img;
PImage stamp_img;

//Variables - bright orange
PImage[] variableBlock_img = new PImage[11];
PImage set_VAR_to_X_img;
PImage change_VAR_by_X_img;
PImage show_variable_X_img;
PImage hide_variable_X_img;
PImage add_X_to_LIST_img;
PImage delete_X_of_LIST_img;
PImage insert_X_at_X_of_LIST_img;
PImage replace_item_X_of_LIST_with_X_img;
PImage item_X_of_LIST_img;
PImage length_of_LIST_img;
PImage LIST_contains_X_img;


void setBlockImages() {
  int imageLoadTime = millis(); //CHRIS
  //Colors first!
  blockColor[0] = color(159,166,212);
  blockColor[1] = color( 29,217,230);
  blockColor[2] = color(187,158,227);
  blockColor[3] = color(142,250,219);
  blockColor[4] = color(210,168,217);
  blockColor[5] = color( 66,230,194);
  blockColor[6] = color(117,255,161);
  blockColor[7] = color(20, 214,245);
  blockColor[8] = color(200);

  //PImages!!!
  //Motion - blue
  motionBlock_img[0]  = loadImage("blockImages/move_X_steps.png");
  motionBlock_img[1]  = loadImage("blockImages/turn_X_degrees.png");
  motionBlock_img[2]  = loadImage("blockImages/point_in_direction.png");
  motionBlock_img[3]  = loadImage("blockImages/point_towards_X.png");
  motionBlock_img[4]  = loadImage("blockImages/go_to_x_X_y_X.png");
  motionBlock_img[5]  = loadImage("blockImages/go_to_X.png");
  motionBlock_img[6]  = loadImage("blockImages/glide_X_seconds_to_x_X_y_X.png");
  motionBlock_img[7]  = loadImage("blockImages/change_x_by_X.png");
  motionBlock_img[8]  = loadImage("blockImages/set_x_to_X.png");
  motionBlock_img[9]  = loadImage("blockImages/change_y_by_X.png");
  motionBlock_img[10] = loadImage("blockImages/set_y_to_X.png");
  motionBlock_img[11] = loadImage("blockImages/if_on_edge_bounce.png");
  motionBlock_img[12] = loadImage("blockImages/x_position.png");
  motionBlock_img[13] = loadImage("blockImages/y_position.png");
  motionBlock_img[14] = loadImage("blockImages/direction.png");

  //Control - yellow-orange
  controlBlock_img[0]  = loadImage("blockImages/when_green_flag_clicked.png");
  controlBlock_img[1]  = loadImage("blockImages/when_X_key_pressed.png");
  controlBlock_img[2]  = loadImage("blockImages/when_X_clicked.png");
  controlBlock_img[3]  = loadImage("blockImages/wait_X_seconds.png");
  controlBlock_img[4]  = loadImage("blockImages/forever.png");
  controlBlock_img[5]  = loadImage("blockImages/repeat.png");
  controlBlock_img[6]  = loadImage("blockImages/broadcast.png");
  controlBlock_img[7]  = loadImage("blockImages/broadcast_and_wait.png");
  controlBlock_img[8]  = loadImage("blockImages/when_I_receive.png");
  controlBlock_img[9]  = loadImage("blockImages/forever_if.png");
  controlBlock_img[10] = loadImage("blockImages/If.png");
  controlBlock_img[11] = loadImage("blockImages/if_else.png");
  controlBlock_img[12] = loadImage("blockImages/wait_until.png");
  controlBlock_img[13] = loadImage("blockImages/repeat_until.png");
  controlBlock_img[14] = loadImage("blockImages/stop_script.png");
  controlBlock_img[15] = loadImage("blockImages/stop_all.png");

  //Looks - purple
  looksBlock_img[0]  = loadImage("blockImages/switch_to_background_X.png");
  looksBlock_img[1]  = loadImage("blockImages/next_background.png");
  looksBlock_img[2]  = loadImage("blockImages/background_number.png");
  looksBlock_img[3]  = loadImage("blockImages/switch_to_costume_X.png");
  looksBlock_img[4]  = loadImage("blockImages/next_costume.png");
  looksBlock_img[5]  = loadImage("blockImages/costume_number.png");
  looksBlock_img[6]  = loadImage("blockImages/say_X_for_X_seconds.png");
  looksBlock_img[7]  = loadImage("blockImages/say_X.png");
  looksBlock_img[8]  = loadImage("blockImages/think_X_for_X_seconds.png");
  looksBlock_img[9]  = loadImage("blockImages/think_X.png");
  looksBlock_img[10] = loadImage("blockImages/change_X_effect_by_X.png");
  looksBlock_img[11] = loadImage("blockImages/set_X_effect_to_X.png");
  looksBlock_img[12] = loadImage("blockImages/clear_graphic_effects.png");
  looksBlock_img[13] = loadImage("blockImages/change_size_by_X.png");
  looksBlock_img[14] = loadImage("blockImages/set_size_to_X_percent.png");
  looksBlock_img[15] = loadImage("blockImages/size.png");
  looksBlock_img[16] = loadImage("blockImages/show.png");
  looksBlock_img[17] = loadImage("blockImages/hide.png");
  looksBlock_img[18] = loadImage("blockImages/go_to_front.png");
  looksBlock_img[19] = loadImage("blockImages/go_back_X_layers.png");

  //Sensing - teal
  sensingBlock_img[0]  = loadImage("blockImages/touching_X.png");
  sensingBlock_img[1]  = loadImage("blockImages/touching_color_COLOR.png");
  sensingBlock_img[2]  = loadImage("blockImages/color_COLOR_is_touching_COLOR.png");
  sensingBlock_img[3]  = loadImage("blockImages/ask_X_and_wait.png");
  sensingBlock_img[4]  = loadImage("blockImages/answer.png");
  sensingBlock_img[5]  = loadImage("blockImages/mouse_x.png");
  sensingBlock_img[6]  = loadImage("blockImages/mouse_y.png");
  sensingBlock_img[7]  = loadImage("blockImages/mouse_down.png");
  sensingBlock_img[8]  = loadImage("blockImages/key_X_pressed.png");
  sensingBlock_img[9]  = loadImage("blockImages/distance_to_X.png");
  sensingBlock_img[10] = loadImage("blockImages/reset_timer.png");
  sensingBlock_img[11] = loadImage("blockImages/timer.png");
  sensingBlock_img[12] = loadImage("blockImages/X_of_X.png");
  sensingBlock_img[13] = loadImage("blockImages/loudness.png");
  sensingBlock_img[14] = loadImage("blockImages/loud.png");
  sensingBlock_img[15] = loadImage("blockImages/X_sensor_value.png");
  sensingBlock_img[16] = loadImage("blockImages/sensor_X.png");

  //Sound - pink
  soundBlock_img[0]  = loadImage("blockImages/play_sound_X.png");
  soundBlock_img[1]  = loadImage("blockImages/play_sound_X_until_done.png");
  soundBlock_img[2]  = loadImage("blockImages/stop_all_sounds.png");
  soundBlock_img[3]  = loadImage("blockImages/play_drum_X_for_X_beats.png");
  soundBlock_img[4]  = loadImage("blockImages/rest_for_X_beats.png");
  soundBlock_img[5]  = loadImage("blockImages/play_note_X_for_X_beats.png");
  soundBlock_img[6]  = loadImage("blockImages/set_instrument_to_X.png");
  soundBlock_img[7]  = loadImage("blockImages/change_volume_by_X.png");
  soundBlock_img[8]  = loadImage("blockImages/set_volume_to_X_percent.png");
  soundBlock_img[9]  = loadImage("blockImages/volume.png");
  soundBlock_img[10] = loadImage("blockImages/change_tempo_by_X.png");
  soundBlock_img[11] = loadImage("blockImages/set_tempo_to_X_bpm.png");
  soundBlock_img[12] = loadImage("blockImages/tempo.png");

  //Operators - lime green
  operatorsBlock_img[0]  = loadImage("blockImages/plus.png");
  operatorsBlock_img[1]  = loadImage("blockImages/minus.png");
  operatorsBlock_img[2]  = loadImage("blockImages/multiply.png");
  operatorsBlock_img[3]  = loadImage("blockImages/divide.png");
  operatorsBlock_img[4]  = loadImage("blockImages/pick_random_X_to_X.png");
  operatorsBlock_img[5]  = loadImage("blockImages/less_than.png");
  operatorsBlock_img[6]  = loadImage("blockImages/equals.png");
  operatorsBlock_img[7]  = loadImage("blockImages/greater_than.png");
  operatorsBlock_img[8]  = loadImage("blockImages/and.png");
  operatorsBlock_img[9]  = loadImage("blockImages/or.png");
  operatorsBlock_img[10] = loadImage("blockImages/not.png");
  operatorsBlock_img[11] = loadImage("blockImages/join_X_X.png");
  operatorsBlock_img[12] = loadImage("blockImages/letter_X_of_X.png");
  operatorsBlock_img[13] = loadImage("blockImages/length_of_X.png");
  operatorsBlock_img[14] = loadImage("blockImages/mod.png");
  operatorsBlock_img[15] = loadImage("blockImages/round.png");
  operatorsBlock_img[16] = loadImage("blockImages/abs.png");
  operatorsBlock_img[17] = loadImage("blockImages/sqrt.png");
  operatorsBlock_img[18] = loadImage("blockImages/sin.png");
  operatorsBlock_img[19] = loadImage("blockImages/cos.png");
  operatorsBlock_img[20] = loadImage("blockImages/tan.png");
  operatorsBlock_img[21] = loadImage("blockImages/asin.png");
  operatorsBlock_img[22] = loadImage("blockImages/acos.png");
  operatorsBlock_img[23] = loadImage("blockImages/atan.png");
  operatorsBlock_img[24] = loadImage("blockImages/ln.png");
  operatorsBlock_img[25] = loadImage("blockImages/log.png");
  operatorsBlock_img[26] = loadImage("blockImages/e_to_the_power.png");
  operatorsBlock_img[27] = loadImage("blockImages/ten_to_the_power.png");

  //Pen - hunter green
  penBlock_img[0]  = loadImage("blockImages/clear.png");
  penBlock_img[1]  = loadImage("blockImages/pen_down.png");
  penBlock_img[2]  = loadImage("blockImages/pen_up.png");
  penBlock_img[3]  = loadImage("blockImages/set_pen_color_to_COLOR.png");
  penBlock_img[4]  = loadImage("blockImages/change_pen_color_by_X.png");
  penBlock_img[5]  = loadImage("blockImages/set_pen_color_to_X.png");
  penBlock_img[6]  = loadImage("blockImages/change_pen_shade_by_X.png");
  penBlock_img[7]  = loadImage("blockImages/set_pen_shade_to_X.png");
  penBlock_img[8]  = loadImage("blockImages/change_pen_size_by_X.png");
  penBlock_img[9]  = loadImage("blockImages/set_pen_size_to_X.png");
  penBlock_img[10] = loadImage("blockImages/stamp.png");

  //Variables or Lists - bright or dark orange
  variableBlock_img[0]  = loadImage("blockImages/set_VAR_to_X.png");
  variableBlock_img[1]  = loadImage("blockImages/change_VAR_by_X.png");
  variableBlock_img[2]  = loadImage("blockImages/show_variable_X.png");
  variableBlock_img[3]  = loadImage("blockImages/hide_variable_X.png");
  variableBlock_img[4]  = loadImage("blockImages/add_X_to_LIST.png");
  variableBlock_img[5]  = loadImage("blockImages/delete_X_of_LIST.png");
  variableBlock_img[6]  = loadImage("blockImages/insert_X_at_X_of_LIST.png");
  variableBlock_img[7]  = loadImage("blockImages/replace_item_X_of_LIST_with_X.png");
  variableBlock_img[8]  = loadImage("blockImages/item_X_of_LIST.png");
  variableBlock_img[9]  = loadImage("blockImages/length_of_LIST.png");
  variableBlock_img[10] = loadImage("blockImages/LIST_contains_X.png");

  println("Image Load Time : "+ (millis()-imageLoadTime));
}






