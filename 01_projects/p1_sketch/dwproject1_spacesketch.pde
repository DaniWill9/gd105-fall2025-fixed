//starting stuff
import processing.svg.*;

beginRecord(SVG, "spacePlot.svg");

size(735, 420);
background(0);

//background top line
stroke(255);
strokeWeight(4);
line(0,210,30,205);
line(30,205,35,185);
line(35,185,60,183);
line(60,183,100,130);
line(100,130,175,135);
line(175,135,185,100);
line(185,100,215,95);
line(215,95,213,70);
line(213,70,330,0);

//backgroun top line fill
strokeWeight(2);
line(325,0,325,4);
line(315,0,315,9);
line(305,0,305,15);
line(295,0,295,20);
line(285,0,285,26);
line(275,0,275,32);
line(265,0,265,39);
line(255,0,255,45);
line(245,0,245,51);
line(235,0,235,57);
line(225,0,225,63);
line(215,0,215,69);
line(205,0,205,97);
line(195,0,195,98);
line(185,0,185,100);
line(175,0,175,135);
line(165,0,165,134);
line(155,0,155,133);
line(145,0,145,132);
line(135,0,135,132);
line(125,0,125,131);
line(115,0,115,130);
line(105,0,105,130);
line(95,0,95,138);
line(85,0,85,149);
line(75,0,75,162);
line(65,0,65,175);
line(55,0,55,184);
line(45,0,45,185);
line(35,0,35,186);
line(25,0,25,207);
line(15,0,15,208);
line(5,0,5,209);

//background bottom line
strokeWeight(4);
line(735,375,690,360);
line(690,360,670,370);
line(670,370,620,350);
line(620,350,590,375);
line(590,375,560,370);
line(560,370,535,385);
line(535,385,495,370);
line(495,370,470,385);
line(470,385,445,380);
line(445,380,420,400);
line(420,400,400,420);

//background bottom line fill
strokeWeight(2);
line(730,375,730,420);
line(720,372,720,420);
line(710,369,710,420);
line(700,364,700,420);
line(690,360,690,420);
line(680,365,680,420);
line(670,368,670,420);
line(660,365,660,420);
line(650,362,650,420);
line(640,359,640,420);
line(630,355,630,420);
line(620,351,620,420);
line(610,356,610,420);
line(600,365,600,420);
line(590,372,590,420);
line(580,372,580,420);
line(570,372,570,420);
line(560,372,560,420);
line(550,375,550,420);
line(540,380,540,420);
line(530,382,530,420);
line(520,381,520,420);
line(510,378,510,420);
line(500,374,500,420);
line(490,375,490,420);
line(480,377,480,420);
line(470,385,470,420);
line(460,383,460,420);
line(450,382,450,420);
line(440,384,440,420);
line(430,390,430,420);
line(420,398,420,420);
line(410,410,410,420);

//circles or whateva
fill(252, 206, 22); //sun color
stroke(204, 164, 1); //sun line color
circle(65,350,110); //sun shape

fill(234, 180, 16); //sun shine color
stroke(170, 96, 13); //ss line color
triangle(20,255,48,280,15,295); //ss 1
triangle(90,250,100,288,65,280); //ss 2
triangle(150,280,140,320,117,293); //ss 3

fill(108, 107, 104); //mercury color
stroke(69, 69, 68); //mercury line color
circle(190,255,30); //mercury shape

fill(139, 116, 86); //venus color
stroke(87, 73, 55); //venus line color
circle(280,350,40); //venus shape

fill(25, 132, 213); //earf color
stroke(14, 74, 121); //earf line color
circle(300,190,46); //earf shape

fill(176, 67, 24); //mars color
stroke(129, 52, 21); //mars line color
circle(400,270,28); //mars shape

fill(231, 165, 121); //jupiter base color
stroke(142, 102, 75); //jupiter line color
circle(400,105,80); //jupiter shape

fill(151, 115, 66); //saturn color
stroke(95, 73, 41); //saturn line color
circle(560,250,55); //saturn shape

fill(47, 93, 123); //uranus color
stroke(25, 51, 68); //uranus line color
circle(600,125,40); //uranus (haha.) shape

fill(35, 95, 180); //neptune color
stroke(18, 48, 91); //neptune line color
circle(675,50,45); //neptune shape

endRecord();
