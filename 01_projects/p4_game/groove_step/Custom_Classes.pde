//Class for arrow prompts.
class Prompt {
  
  PImage sprite;
  String type;
  boolean active = true;
  int lifetime = 120;

  Prompt (String type) {
    
    this.type = type; 
    if (type.equals ("up") ) sprite = arrowUp;
    else if (type.equals ("down") ) sprite = arrowDown;
    else if (type.equals ("left") ) sprite = arrowLeft;
    else if (type.equals ("right") ) sprite = arrowRight;
    
  }

  void update () {
    
    lifetime--;
    if (lifetime <= 0) active = false;
    
  }

  void display () {
    
    image(sprite, GAME_WIDTH / 2 - sprite.width / 2, 150);
    
  }
  
}

//Class for player data (lives, score, etc).
class Player {
  
  int lives;
  int maxLives;
  int score;

  Player (int maxLives) {
    
    this.maxLives = maxLives;
    this.lives = maxLives;
    this.score = 0;
    
  }

  void reset () {
    
    lives = maxLives;
    score = 0;
    
  }

  void loseLife () {
    
    lives--;
    
  }

  void addScore (int amount) {
    
    score += amount;
    
  }
  
}
