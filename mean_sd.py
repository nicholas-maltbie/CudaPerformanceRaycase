import numpy as np
import sys

if __name__ == "__main__":
    data_file = sys.argv[1]
    file_lines = open(data_file)

    dataset = np.array(list(map(float, [line.strip() for line in file_lines if line.strip() ])))

    file_lines.close()

    print("%1.3f,%1.3f,%1.3f" % (np.median(dataset), np.mean(dataset), np.std(dataset)))

