library(hexSticker)
library(ggplot2)

df <- data.frame(x = c(rep(1:5, each = 20)),
                 y = c(rep(1:20, times = 5)))

# Add missing value
df <- df[-95 ,]

# Remove below hex
df <- df[c(7:20, 26:40, 45:60, 64:80, 83:99),]

# Imputatino points
imps <- data.frame(x = c( 7, 7.4, 8.4, 12.9,  9,   8.1,  11.8),
                   y = c(18, 7.2,  9.1,  17, 19,   15,  11.5))

df <- rbind(df, imps)
df$group <- c(rep("a", nrow(df) - 7), rep("b", 7))

ggplot(df, aes(x = x, y = y, color = group, shape = group)) + geom_point()

imp_color <- "#a44a3f"

g <- ggplot(df, aes(x = x, y = y)) +
   geom_line(data = data.frame(x = c(5.1, imps[1,1]), y = c(15, imps[1, 2])),
             colour = imp_color) +
   geom_line(data = data.frame(x = c(5.1, imps[2,1]), y = c(15, imps[2, 2])),
             colour = imp_color) +
   geom_line(data = data.frame(x = c(5.1, imps[3,1]), y = c(15, imps[3, 2])),
             colour = imp_color) +
   geom_line(data = data.frame(x = c(5.1, imps[4,1]), y = c(15, imps[4, 2])),
             colour = imp_color) +
   geom_line(data = data.frame(x = c(5.1, imps[5,1]), y = c(15, imps[5, 2])),
             colour = imp_color) +
   geom_line(data = data.frame(x = c(5.1, imps[6,1]), y = c(15, imps[6, 2])),
             colour = imp_color) +
   geom_line(data = data.frame(x = c(5.1, imps[7,1]), y = c(15, imps[7, 2])),
             colour = imp_color) +
   geom_point(aes(group = group, color = group, shape = group, size = group)) +
   theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        legend.position = "none",
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA)) +
   scale_shape_manual(values = c(16, 18)) +
   scale_color_manual(values = c("black", imp_color)) +
   scale_size_manual(values = c(1, 3))

sticker(g, package = "howManyImputations",
        filename = "hexsticker/howManyImputations.png",
        s_width = 1.5, s_height = 1.3, s_x = .9, s_y = .69,
        p_y = 1.4, p_size = 13, p_color = "#276289",
        h_color = "#003A5E", h_fill = "#FFF7D6")
