def boxplot(Data):
    """
    This function takes an array, and returns the values of quartiles (q1, q2, q3), the inter-quartile range (q3 - q1),
    the outlier points, and the extreme outlier points.
    Output: q1, q2, q3, iqr, outliers_vector, extreme_outliers_vector
    """
    ## Import the required modules
    import numpy as np
    import math as math
    
    ### Sort the Data array
    Data.sort()
    
    ## Calculate the median (Q2)
    if np.size(x)%2 == 0:
        q2 = (x[int(np.size(x)*0.5-1)] + x[int(np.size(x)*0.5)])/ 2
    else:
        q2 = x[math.floor(np.size(x)*0.5)]
    
    
    ## Calculate the first quartile (Q1)
    if np.size(x)%4 == 0:
        q1 = (x[int(np.size(x)*0.25-1)] + x[int(np.size(x)*0.25)])/ 2
    else:
        q1 = x[math.floor(np.size(x)*0.25)]

    ## Calculate the third quartile (Q1)
    if np.size(x)%4 == 0:
        q3 = (x[int(np.size(x)*0.75-1)] + x[int(np.size(x)*0.75)])/ 2
    else:
        q3 = x[math.floor(np.size(x)*0.75)]
    
    
    ## Calculate the inter-quartile range (IQR)
    IQR = q3 - q1

    ## Calculate the extreme outliers points
    extreme_outliers = np.concatenate((x[x<q1-3*IQR], x[x>q3+3*IQR]), axis=0)
    
    ## Calculate the outliers points
    all_outliers = np.concatenate((x[x<q1-1.5*IQR], x[x>q3+1.5*IQR]), axis=0)
    
    # Assumption 1 (outliers belong to the extreme outlier range)
    outliers = all_outliers
    
    # Assumption 2 (outliers do not belong to the extreme outlier range)
    #temp = all_outliers[all_outliers<=q3+3*IQR]
    #outliers = temp[temp>=q1-3*IQR]
    
    return q1,q2,q3,IQR,outliers,extreme_outliers
