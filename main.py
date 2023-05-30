from uber_agent import what_distance, best_path, hundred_maps
from utils.enum.Enum import Cities, Approachs, Preference 

print(hundred_maps(Approachs.BUSCA_GULOSA.value, Cities.SP.value, Cities.SSA.value, Cities.MA.value, Preference.SECURE.value))