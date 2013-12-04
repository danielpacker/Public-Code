##############################################################################
#
# Author: Daniel Packer <dp@danielpacker.org>
#
# Interactive monty hall game
#

import pygame
import random
import sys
from pygame.locals import *
flags = FULLSCREEN | DOUBLEBUF
# Define some colors
black = ( 0, 0, 0)
white = ( 255, 255, 255)
green = ( 0, 255, 0)
red = ( 255, 0, 0)
pygame.init()
# Set the height and width of the screen
height=480
width=640
size=[width, height]
screen=pygame.display.set_mode(size)
if len(sys.argv) > 1:
  modes = pygame.display.list_modes(32)
  if not modes:
    print '16bit not supported'
  else:
    print 'Found Resolution:', modes[0]
  screen = pygame.display.set_mode(modes[0], flags, 16)
size = screen.get_size()
width,height = size
pygame.display.set_caption("Monty Hall Game")
#Loop until the user clicks the close button.
done=False
# Used to manage how fast the screen updates
clock=pygame.time.Clock()

counter_fontsize = width/10 #100;
result_fontsize = width/10 #80;
welcome_fontsize = width/20 #80;
counter_font = pygame.font.Font(None, counter_fontsize)
result_font = pygame.font.Font(None, result_fontsize)
welcome_font = pygame.font.Font(None, welcome_fontsize)

background=pygame.image.load("2009lmadzonkgoat.jpg").convert()
background=pygame.transform.scale(background,size)
screen.blit(background, (0, 0))

# door states: 0-closed-loser, 1-closed-winner, 2-open-loser, 3-open-winner
door_choice = -1
doors = [0, 0, 0]
def init_doors():
  global doors
# init doors and set one of them to true
  doors = [0, 0, 0]
  index = random.randint(0,2)
  doors[index] = 1

def draw_doors():
  door_width = width/5;
  door_height = height-height/2;
  door_color = green;
  avail_width = width-3*door_width;
  avail_height = height - door_height;
  y_offset = avail_height/2 + height/20;
  space_between_doors = avail_width/4;
  x_offset = space_between_doors;
  for i in range(3):
    if (doors[i] == 2):
      door_color = red
    elif (doors[i] == 3):
      door_color = (0,0,255) 
    else:
      door_color = green
    pygame.draw.rect(screen, door_color, (x_offset, y_offset, door_width, door_height))
    pygame.draw.circle(screen, black, (x_offset+door_width/7, y_offset+door_height/2), door_width/20)

    # Draw chosen door with a border, otherwise simple black border
    if (i == door_choice):
      pygame.draw.rect(screen, white, (x_offset, y_offset, door_width, door_height), 10)
    else:
      pygame.draw.rect(screen, black, (x_offset, y_offset, door_width, door_height), 1)
      
 
    result_str = ""
    if (game_state == 3) and (door_choice == i): 
      if (doors[door_choice]==3):
        result_str = ":D"
      else:
        result_str = ":("
      result_text = result_font.render(result_str, True, white)
      (x,y) = result_font.size(result_str)
      screen.blit(result_text, [x_offset+door_width/2 - x/2, y_offset+door_height/2 - y/2])

     
    x_offset = x_offset + space_between_doors + door_width;

def door_states():
  print("Door choice: "+str(door_choice))
  print"Door states: "
  for i in range(3):
    print("[" + str(i) + ":"+str(doors[i]) +"] ")
  print("")
    
def choose_door(i):
  global door_choice
  if (doors[i] < 2):
    door_choice = i

def choose_random_door():
  global door_choice
  door = random.randint(0,2)
  door_choice = door

def open_door():
  # find a losing door to open
  loserfound = False
  while (loserfound == False):
    door = random.randint(0,2)
    if (doors[door] == 0 and door != door_choice):
      doors[door] = 2
      loserfound = True
      #print("opening door "+str(door))

def reveal_winner():
  global games_lost, games_won, games_total
  for i in range(3):
    if (doors[i] < 2):
      doors[i] += 2
  if (doors[door_choice] == 3):
    games_won += 1
  else:
    games_lost += 1
  games_total += 1

def swap_door_choice():
  global door_choice
  global swap
  # one door has been revealed, swap the other two
  # find the unrevealed door and swap w/ chosen
  orig = door_choice
  for i in range(3):
    if (i != door_choice):
      #print(str(i) + " is not our door choice which is " + str(door_choice))
      if (doors[i] < 2): 
        #print(" and it has value < 2 which is " +str(doors[i]))
        door_choice = i
        #print("swapped "+str(orig)+" for "+str(i))
        break
    #if (i != door_choice) and (doors[i] < 2): door_choice = i

def reset_counters():
  global games_won, games_lost, games_total
  games_won, games_lost, games_total = 0, 0, 0

def reset_game():
  global game_state
  init_doors()
  door_choice = -1
  game_state = 1

def draw_welcome():
  welcome1 = "Monty Hall Game"
  welcome2 = "Coded in Python with Pygame"
  welcome3 = "Daniel Packer <dp@danielpacker.org>"
  fcolor = red
  for i in range(6):
    i = i - 2;
    if (i == 3): i,fcolor = 0,white
    y_off = counter_fontsize;
    x_off = width/2;
    welcome1_r = counter_font.render(welcome1, True, fcolor)
    (x,y) = counter_font.size(welcome1)
    screen.blit(welcome1_r, [width/2 - x/2+i, y_off])
    welcome2_r = welcome_font.render(welcome2, True, fcolor)
    (x,y) = welcome_font.size(welcome2)
    screen.blit(welcome2_r, [width/2 - x/2+i, y_off*3])
    welcome3_r = welcome_font.render(welcome3, True, fcolor)
    (x,y) = welcome_font.size(welcome3)
    screen.blit(welcome3_r, [width/2 - x/2+i, y_off*4])


def draw_counters():
  y_off = height - counter_fontsize 
  x_off = width/3

  pygame.draw.rect(screen, white, (0, y_off, width, counter_fontsize), 0)
  win_percentage = " "
  win_str = ""
  #print(str(games_won) + " : " + str(games_total))
  if (games_total > 0): 
    win_percentage = (games_won*1.0/games_total*1.0) * 100
    win_str = str('%.2f' % win_percentage)
    #print("printing wins " + win_str)
  winnage_text = counter_font.render("Success: "+ win_str +"%", True, white)
  (x,y) = counter_font.size("Success: "+ win_str +"%")
  screen.blit(winnage_text, [width/2 - x/2, counter_fontsize/3])
  
  lost_text = counter_font.render(str(games_lost)+" :(", True, (255,0,0))
  (x,y) = counter_font.size(str(games_lost)+" :(")
  screen.blit(lost_text, [x_off/2 - x/2, y_off])

  total_text = counter_font.render(str(games_total), True, (200,200,200))
  (x,y) = counter_font.size(str(games_total))
  screen.blit(total_text, [x_off+(x_off/2) - x/2, y_off])

  won_text = counter_font.render(str(games_won)+" :D", True, (0,0,255))
  (x,y) = counter_font.size(str(games_won)+" :D")
  screen.blit(won_text, [x_off*2+(x_off/2) - x/2, y_off])
 
 # start game
reset_game()

# game variables
started, auto, swap, sim, reset, proceed =  False, False, False, False, False, False
games_total, games_won, games_lost, win_percentage = 0, 0, 0, 0
game_state = 1 # 1 = started, 2 = second door, 3 = finished
pygame.key.set_repeat(100,20)

while done==False:
  # Set the screen background
  screen.fill(black)
  screen.blit(background, (0,0))
  # ALL CODE TO DRAW SHOULD GO BELOW THIS COMMENT

  # draw doors
  if (started):
    draw_doors()
    draw_counters()
  else:
    draw_welcome()

  if (game_state == 1):
    if (proceed) or (auto):
      if (auto): choose_random_door()
      if (door_choice != -1):
        #door_states()
        open_door()
        #door_states()
        game_state = 2;
        proceed = False;
      else:
        proceed = False; # avoid first turn glitch
  elif (game_state == 2):
    if (proceed) or (auto):
      if (swap): swap_door_choice()
      reveal_winner()
      print("done")
      game_state = 3
      proceed = False
  elif (game_state == 3):
    if (proceed) or (auto):
      proceed = False
      reset_game()

  # ALL CODE TO DRAW SHOULD GO ABOVE THIS COMMENT
  #clock.tick(30) # 20 fps
  
  for event in pygame.event.get():
    if event.type == pygame.QUIT:
      done = True # Be IDLE friendly!
    elif event.type == pygame.KEYDOWN:
      if event.key == pygame.K_ESCAPE:
        done = True # Be IDLE friendly!
      elif event.key == pygame.K_s:
        if (swap): swap = False 
        else:      swap = True
        print("swap mode toggled: "+str(swap))
      elif event.key == pygame.K_a:
        if (auto): auto = False 
        else:      auto = True
        print("auto mode toggled: "+str(auto))
      elif event.key == pygame.K_r:     reset_counters()
      elif event.key == pygame.K_SPACE: proceed, started = True, True
      elif event.key == pygame.K_1:     choose_door(0)
      elif event.key == pygame.K_2:     choose_door(1)
      elif event.key == pygame.K_3:     choose_door(2)
  
  pygame.display.flip()
  #pygame.display.update()
pygame.quit ()
