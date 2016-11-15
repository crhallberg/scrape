//Booleans_mouseOvers


Boolean mouseOver_box(float x,float y, float Width,float Height) {
  if(mouseX>=x && mouseX<=x+Width  &&  mouseY>=y && mouseY<=y+Height)
    return true;
  else
    return false;
}


Boolean mouseOver_circle(float x, float y, float diameter) {
  float distanceToMouse = sqrt((mouseX-x)*(mouseX-x) + (mouseY-y)*(mouseY-y));
  if(distanceToMouse<=diameter)
    return true;
  else
    return false;
}

