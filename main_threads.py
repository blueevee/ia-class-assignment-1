from concurrent.futures import ProcessPoolExecutor
import multiprocessing
import threading
from uber_agent import what_distance, best_path, hundred_maps
from utils.enum.Enum import Cities, Approachs, Preference 

def firstMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 1, 14)

def secondMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 14, 27)

def thirdMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 27, 40)

def fourthMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 40, 52)

def fifthMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 52, 65)

def sixthMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 65, 78)

def seventhMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 78, 91)

def eigthMaps():
  hundred_maps(Approachs.A_ESTRELA.value, Cities.SP.value, Cities.NT.value, Cities.MA.value, Preference.SECURE.value, 91, 101)

if __name__ == '__main__':
  multiprocessing.freeze_support()
  t1 = threading.Thread(target=firstMaps, name='t1')
  t2 = threading.Thread(target=secondMaps, name='t2')
  t3 = threading.Thread(target=thirdMaps, name='t3')
  t4 = threading.Thread(target=fourthMaps, name='t4')
  t5 = threading.Thread(target=fifthMaps, name='t5')
  t6 = threading.Thread(target=sixthMaps, name='t6')
  t7 = threading.Thread(target=seventhMaps, name='t7')
  t8 = threading.Thread(target=eigthMaps, name='t8')

  t1.start()
  t2.start()
  t3.start()
  t4.start()
  t5.start()
  t6.start()
  t7.start()
  t8.start()

