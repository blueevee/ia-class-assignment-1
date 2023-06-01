from concurrent.futures import ProcessPoolExecutor
import multiprocessing
from uber_agent import what_distance, best_path, hundred_maps
from utils.enum.Enum import Cities, Approachs, Preference 

def firstMaps():
  hundred_maps(Approachs.BUSCA_GULOSA.value, Cities.SP.value, Cities.SSA.value, Cities.MA.value, Preference.SECURE.value, 1, 26)

def secondMaps():
  hundred_maps(Approachs.BUSCA_GULOSA.value, Cities.SP.value, Cities.SSA.value, Cities.MA.value, Preference.SECURE.value, 26, 50)

def thirdMaps():
  hundred_maps(Approachs.BUSCA_GULOSA.value, Cities.SP.value, Cities.SSA.value, Cities.MA.value, Preference.SECURE.value, 50, 75)

def fourthMaps():
  hundred_maps(Approachs.BUSCA_GULOSA.value, Cities.SP.value, Cities.SSA.value, Cities.MA.value, Preference.SECURE.value, 75, 101)

def maps():
  hundred_maps(Approachs.BUSCA_GULOSA.value, Cities.SP.value, Cities.SSA.value, Cities.MA.value, Preference.SECURE.value, 1, 101)


if __name__ == '__main__':
  hundred_maps(Approachs.BFS.value, Cities.SP.value, Cities.SSA.value, Cities.MA.value, Preference.FAST.value, 1, 2)
  # multiprocessing.freeze_support()
  # executor = ProcessPoolExecutor(4)

  # firstProcess = multiprocessing.Process(target=firstMaps)
  # firstProcess.start()


  # secondProcess = multiprocessing.Process(target=secondMaps)
  # secondProcess.start()

  # thirdProcess = multiprocessing.Process(target=thirdMaps)
  # thirdProcess.start()

  # fourthProcess = multiprocessing.Process(target=fourthMaps)
  # fourthProcess.start()

  # future = executor.submit(maps)

