import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_csv('../results/greedy/fast/results_greedy.csv')

file = df['File']
current_memory = df['Current Memory (MB)']
peak_memory = df['Peak Memory (MB)']

plt.figure(figsize=(10, 6))
plt.plot(file, current_memory, 'o-', label='Current Memory')
plt.plot(file, peak_memory, 'o-', label='Peak Memory')
plt.xlabel('File')
plt.ylabel('Memory (MB)')
plt.title('Memory Usage')
plt.legend()

# Ajuste do espaçamento entre os pontos no eixo X
plt.xticks(np.arange(0, 100, step=0.5), rotation=45, ha='right') 

plt.tight_layout() 
plt.show()
