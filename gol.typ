#import "@preview/cetz:0.1.2"

Поле представляет из себя потенциально бесконечную сетку. В каждой клетке может
быть жизнь. Каждый ход, если у живой клетки два или три живых соседа, она
остаётся живой, иначе умирает. Если у мёртвой клетки ровно три живых соседа, то
в ней зарождается жизнь. Обозначим чёрным наличие жизни:

#let field(n, m) = {
  import cetz.draw: *
  if (m == none) { m = n }
  for i in range(0, m) {
    for j in range(0, n) {
      rect((i, -j), (i + 1, -j - 1))
    }
  }
}

#let alive(i, j) = {
  import cetz.draw: *
  rect((i, -j), (i + 1, -j - 1), fill: black)
}

#let dying(i, j) = {
  import cetz.draw: *
  line((i, -j), (i + 1, -j - 1), stroke: red + 3pt)
  line((i, -j - 1), (i + 1, -j), stroke: red + 3pt)
}

#let born(i, j) = {
  import cetz.draw: *
  circle((i + .5, -j - .5), radius: .15, fill: black)
}

#let canv(f) = pad(1em, cetz.canvas({
  import cetz.draw: *
  scale(.7)
  field(7, 7)
  f
}))

#canv({
  alive(2, 2)
  alive(2, 3)
  alive(2, 4)
  alive(3, 2)
  alive(4, 3)
})

На следующем ходу две клетки умрут "от одиночества", две зародятся:

#grid(columns: 2, canv({
  alive(2, 2)
  alive(2, 3)
  alive(2, 4)
  alive(3, 2)
  alive(4, 3)
  dying(2, 4)
  dying(4, 3)
  born(1, 3)
  born(3, 4)
}), canv({
  alive(2, 2)
  alive(2, 3)
  alive(3, 2)
  alive(1, 3)
  alive(3, 4)
}))

На следующем одна умрёт от одиночества, одна --- от перенаселения. Снова две
зародятся.

#grid(columns: 2, canv({
  alive(2, 2)
  alive(2, 3)
  alive(3, 2)
  alive(1, 3)
  alive(3, 4)

  dying(2, 3)
  dying(3, 4)
  born(1, 2)
  born(2, 4)
}), canv({
  alive(2, 2)
  alive(3, 2)
  alive(1, 3)
  alive(1, 2)
  alive(2, 4)
}))

И так далее.

\ \ \
"Жизнь" развивается довольно непредсказуемым образом. Этот процесс здесь
называется _эволюцией_.

#let canv(n, m, s, f) = pad(1em, cetz.canvas({
  import cetz.draw: *
  scale(s)
  field(n, m)
  f
}))

Есть стационарные конфигурации, которые не меняются с течением времени:

#canv(6, 13, 1, {
  alive(1, 2)
  alive(1, 3)
  alive(2, 2)
  alive(2, 3)
  alive(5, 2)
  alive(5, 3)
  alive(7, 2)
  alive(7, 3)
  alive(6, 1)
  alive(6, 4)
  alive(10, 1)
  alive(10, 2)
  alive(11, 1)
  alive(11, 3)
  alive(11, 4)
  alive(10, 4)
})

Есть, которые осциллируют:
#let s = .53
#grid(columns: 4, canv(5, 5, s, {
  alive(2, 3)
  alive(2, 2)
  alive(2, 1)
}), canv(5, 5, s, {
  alive(3, 2)
  alive(2, 2)
  alive(1, 2)
}), canv(5, 5, s, {
  alive(2, 3)
  alive(2, 2)
  alive(2, 1)
}), canv(5, 5, s, {
  alive(3, 2)
  alive(2, 2)
  alive(1, 2)
}))

И которые перемещаются в пространстве со временем.

#let s = .28
#grid(columns: 5, canv(7, 7, s, {
  alive(2, 2)
  alive(2, 3)
  alive(2, 4)
  alive(3, 2)
  alive(4, 3)
}), canv(7, 7, s, {
  alive(2, 2)
  alive(2, 3)
  alive(3, 2)
  alive(1, 3)
  alive(3, 4)
}), canv(7, 7, s, {
  alive(2, 2)
  alive(3, 2)
  alive(1, 3)
  alive(1, 2)
  alive(2, 4)
}), canv(7, 7, s, {
  alive(2, 2)
  alive(1, 3)
  alive(1, 2)
  alive(2,1)
  alive(3,3)
}), canv(7, 7, s, {
  alive(1, 3)
  alive(1, 2)
  alive(2,1)
  alive(1,1)
  alive(3,2)
}))

И это далеко не всё...

На GoL вполне можно эмулировать компьютер, который выполнит любой алгоритм.