import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

fig, ax = plt.subplots()

a = np.array([[1, -1],
              [1, 1]])
b = np.array([[0, 1],
              [0, 2]])
print(np.matmul(b, a))


ax.grid("minor")
ax.set_title("HELLO")
ax.legend(["SINEWAVE"])

#def animate(i):
#    line.set_ydata(np.sin(x + i / 50))  # update the data.
#    return line,
#
#
#ani = animation.FuncAnimation(
#    fig, animate, interval=20, blit=True, save_count=50)

# To save the animation, use e.g.
#
# ani.save("movie.mp4")
#
# or
#
# writer = animation.FFMpegWriter(
#     fps=15, metadata=dict(artist='Me'), bitrate=1800)
# ani.save("movie.mp4", writer=writer)

plt.show()