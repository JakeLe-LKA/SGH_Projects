# Exercise.

# Please install sandwich package and execute the following code in R :

data(Investment, package="sandwich")
Investment <- as.data.frame(Investment)

# Investments in the USA, an annual time series from 1963 to 1982 with 7 variables. 

# Please investigate factors  related to investments in the USA, create visualization using lattice package.

View(Investment)
summary(Investment)

# Create column 'year' from 1963 to 1982
Investment$Year <- seq(from = 1963, to = 1982)

# Remove missing data
Investment <- Investment[!is.na(Investment$RealInt), ]
#-------------------
# Data Analysis
# library package
library(lattice)

# Real Investment - Invest over years
xyplot(RealInv + Investment ~ Year, data = Investment,
       type = "l",  
       auto.key = list(columns = 2, lines = TRUE, points = FALSE),
       par.settings = list(superpose.line = list(col = c("darkgreen", "darkorange"), lwd = 2)),
       xlab = "Years", ylab = "Values",
       scales = list(y = list(rot = 0)),
       main = "Investment and Real Investment over years")

# Real Interest over years
dotplot(RealInt + Interest ~ Year, data = Investment,
        groups = colnames(Investment)["RealInt", "Interest"], # Gắn tên cho các nhóm
        auto.key = list(columns = 2, points = TRUE, lines = FALSE), 
        pch = c(16, 20), # Biểu tượng: chấm đặc cho Interest, vòng tròn cho RealInt
        col = c("darkgreen", "darkorange"), # Màu sắc khác nhau
        cex = 1.2, # Kích thước của điểm
        xlab = "Years", ylab = "Interest Rates",
        main = "Interest and Real Interest Rates Over Years",
        par.settings = list(superpose.symbol = list(col = c("darkgreen", "darkorange"), pch = c(16, 20))))

# Real GNP and GNP over years
xyplot(RealGNP + GNP ~ Year, data = Investment,
       type = "l",  
       auto.key = list(columns = 2, lines = TRUE, points = FALSE),
       par.settings = list(superpose.line = list(col = c("darkgreen", "darkorange"), lwd = 2)),
       xlab = "Years", ylab = "Product",
       scales = list(y = list(rot = 0)),
       main = "Real GNP and GNP over years")

# Correlation plot between Real variables
real_vars <- Investment[, c("RealGNP", "RealInv", "RealInt")]

splom(real_vars,
      main = "Scatter Plots of Real Variables",
      col = "darkgreen", pch = 16)

# Correlation plot between Real variables
nom_vars <- Investment[, c("GNP", "Investment", "Interest")]

splom(nom_vars,
      main = "Scatter Plots of Nominal Variables",
      col = "darkorange", pch = 16)

# Create a categorical column for before and after 1975
Investment$Period <- factor(Investment$Year <= 1975, 
                            labels = c("After 1975", "Before 1975"))

# Boxplot of Real Investment Before and After 1975
bwplot(
  RealInv ~ factor(Year > 1975, labels = c("Before 1975", "After 1975")), 
  data = Investment, 
  xlab = "Time Period", 
  ylab = "Real Investment",
  main = "Comparison of Real Investment Before and After 1975",
  col = c("skyblue", "pink")
)

# Real Interest rate over time
xyplot(
  RealInt ~ Year, 
  data = Investment, 
  type = "l", 
  main = "Real Interest Rate Over Time",
  ylab = "Rate",
  panel = function(...) {
    panel.xyplot(...)
    panel.abline(v = 1975, col = "red", lty = 2) # Highlight 1975
  }
)

# Comparison of Real Interest rate Before and After the year 1975
dotplot(
  RealInt ~ Period, 
  data = Investment,
  groups = Period,
  col = c("skyblue", "pink"),
  pch = 16,
  jitter.y = TRUE, 
  xlab = "Time Period",
  ylab = "Real Interest Rate",
  main = "Real Interest Rates Before and After 1975",
  scales = list(x = list(rot = 0)), 
  panel = function(x, y, ...) {
    panel.dotplot(x, y, ...)
    panel.abline(v = 1.5, lty = 2, col = "gray50") 
  }
)




