Pandas使用
=========

{{toc}}

## 概述

复杂矩阵/数据帧运算, 基本就是R的python版.

## 常用方法

 - Series 构建向量, 与numpy的array相似

```python

In [6]: pd.Series([1,2,3,4,5,6])
Out[6]: 
0    1
1    2
2    3
3    4
4    5
5    6
dtype: int64

```

 - DataFrame 构建数据帧

```python
In [8]: pd.DataFrame([[1,2,3],[1,2,3,4],[1,2,3],[4,5,6,7,8,9]], index=list('ABCD'), columns=list('abcdef'))
Out[8]: 
   a  b  c    d    e    f
   A  1  2  3  NaN  NaN  NaN
   B  1  2  3  4.0  NaN  NaN
   C  1  2  3  NaN  NaN  NaN
   D  4  5  6  7.0  8.0  9.0
```

 - date_range 构建时间向量

```python
In [9]: pd.date_range('20180101', periods=6, freq='M')
Out[9]: 
DatetimeIndex(['2018-01-31', '2018-02-28', '2018-03-31', '2018-04-30',
               '2018-05-31', '2018-06-30'],
              dtype='datetime64[ns]', freq='M')


```

 - head / tail / index 展示向量数据

```python
In [10]: d=pd.DataFrame([[1,2,3],[1,2,3,4],[1,2,3],[4,5,6,7,8,9]], columns=list('abcdef'))

In [11]: d.head(3)
Out[11]: 
   a  b  c    d   e   f
   0  1  2  3  NaN NaN NaN
   1  1  2  3  4.0 NaN NaN
   2  1  2  3  NaN NaN NaN

In [12]: d.tail(3)
Out[12]: 
   a  b  c    d    e    f
   1  1  2  3  4.0  NaN  NaN
   2  1  2  3  NaN  NaN  NaN
   3  4  5  6  7.0  8.0  9.0

In [14]: d[d['b']>2]
Out[14]: 
   a  b  c    d    e    f
   3  4  5  6  7.0  8.0  9.0

```

 - describe 数据帧简单统计

```python
In [15]: d.describe()
Out[15]: 
          a     b     c        d    e    f
count  4.00  4.00  4.00  2.00000  1.0  1.0
mean   1.75  2.75  3.75  5.50000  8.0  9.0
std    1.50  1.50  1.50  2.12132  NaN  NaN
min    1.00  2.00  3.00  4.00000  8.0  9.0
25%    1.00  2.00  3.00  4.75000  8.0  9.0
50%    1.00  2.00  3.00  5.50000  8.0  9.0
75%    1.75  2.75  3.75  6.25000  8.0  9.0
max    4.00  5.00  6.00  7.00000  8.0  9.0
```

 - T 数据帧/向量转置

```python
In [17]: d
Out[17]: 
   a  b  c    d    e    f
   0  1  2  3  NaN  NaN  NaN
   1  1  2  3  4.0  NaN  NaN
   2  1  2  3  NaN  NaN  NaN
   3  4  5  6  7.0  8.0  9.0

In [18]: d.T
Out[18]: 
     0    1    2    3
     a  1.0  1.0  1.0  4.0
     b  2.0  2.0  2.0  5.0
     c  3.0  3.0  3.0  6.0
     d  NaN  4.0  NaN  7.0
     e  NaN  NaN  NaN  8.0
     f  NaN  NaN  NaN  9.0
```

 - sort_value 排序

```python
In [21]: d.sort_values(by='c', ascending=False)
Out[21]: 
   a  b  c    d    e    f
   3  4  5  6  7.0  8.0  9.0
   0  1  2  3  NaN  NaN  NaN
   1  1  2  3  4.0  NaN  NaN
   2  1  2  3  NaN  NaN  NaN
```

 - loc / iloc / at / iat  筛选

```python

In [25]: d.loc[:,['a','c']]
Out[25]: 
   a  c
   0  1  3
   1  1  3
   2  1  3
   3  4  6

In [26]: d.iloc[2]
Out[26]: 
   a    1.0
   b    2.0
   c    3.0
   d    NaN
   e    NaN
   f    NaN
Name: 2, dtype: float64

In [27]: d.iloc[[1,3],[0,2]]
Out[27]: 
   a  c
   1  1  3
   3  4  6

In [31]: d.at[0,'a']
Out[31]: 1

In [32]: d.at[0,'b']
Out[32]: 2

In [33]: d.at[2,'b']
Out[33]: 2

In [34]: d.at[3,'b']
Out[34]: 5

In [42]: d.iat[3,1]
Out[42]: 5
```

 - isin / isna

```python
In [46]: d
Out[46]: 
      a  b  c    d    e    f
   0  1  2  3  NaN  NaN  NaN
   1  1  2  3  4.0  NaN  NaN
   2  1  2  3  NaN  NaN  NaN
   3  4  5  6  7.0  8.0  9.0

In [47]: d.isin([2,7])
Out[47]: 
          a      b      c      d      e      f
   0  False   True  False  False  False  False
   1  False   True  False  False  False  False
   2  False   True  False  False  False  False
   3  False  False  False   True  False  False

In [50]: d.isna()
Out[50]: 
          a      b      c      d      e      f
   0  False  False  False   True   True   True
   1  False  False  False  False   True   True
   2  False  False  False   True   True   True
   3  False  False  False  False  False  False
```
 - apply 

```python
In [56]: d
Out[56]: 
      a  b  c    d    e    f
   0  1  2  3  NaN  NaN  NaN
   1  1  2  3  4.0  NaN  NaN
   2  1  2  3  NaN  NaN  NaN
   3  4  5  6  7.0  8.0  9.0

In [53]: d.apply(pd.isna)
Out[53]: 
          a      b      c      d      e      f
   0  False  False  False   True   True   True
   1  False  False  False  False   True   True
   2  False  False  False   True   True   True
   3  False  False  False  False  False  False

In [57]: d.apply(sum)
Out[57]: 
a     7.0
b    11.0
c    15.0
d     NaN
e     NaN
f     NaN
dtype: float64
```

 - concat / merge / append / group

```python
In [80]: d
Out[80]: 
   a  b  c    d    e    f
0  1  2  3  NaN  NaN  NaN
1  1  2  3  4.0  NaN  NaN
2  1  2  3  NaN  NaN  NaN
3  4  5  6  7.0  8.0  9.0

In [81]: e
Out[81]: 
    a   b   c   d   e   f   g
0  21  22  23  24  25  26  27

In [82]: pd.concat([d,e])
Out[82]: 
    a   b   c     d     e     f     g
0   1   2   3   NaN   NaN   NaN   NaN
1   1   2   3   4.0   NaN   NaN   NaN
2   1   2   3   NaN   NaN   NaN   NaN
3   4   5   6   7.0   8.0   9.0   NaN
0  21  22  23  24.0  25.0  26.0  27.0

In [93]: d.append(e)
Out[93]: 
    a   b   c     d     e     f     g
0   1   2   3   NaN   NaN   NaN   NaN
1   1   2   3   4.0   NaN   NaN   NaN
2   1   2   3   NaN   NaN   NaN   NaN
3   4   5   6   7.0   8.0   9.0   NaN
0  21  22  23  24.0  25.0  26.0  27.0

```

 - to_csv / read_csv

```python
In [99]: d.to_csv('d.csv')

-----------
cat d.csv

,a,b,c,d,e,f
0,1,2,3,,,
1,1,2,3,4.0,,
2,1,2,3,,,
3,4,5,6,7.0,8.0,9.0
------------

In [102]: pd.read_csv('d.csv')
Out[102]: 
   Unnamed: 0  a  b  c    d    e    f
0           0  1  2  3  NaN  NaN  NaN
1           1  1  2  3  4.0  NaN  NaN
2           2  1  2  3  NaN  NaN  NaN
3           3  4  5  6  7.0  8.0  9.0

```

 - to_hdf / read_hdf

{{note(
 - 可以写入多个变量
 - 相同变量命会覆盖
 - 按照变量名来抽取对应的值
      )}}

```python
In [14]: e
Out[14]: 
    a   b   c   d   e   f   g
0  21  22  23  24  25  26  27

In [15]: e.to_hdf('e.h5', 'a')

In [16]: e.to_hdf('e.h5', 'b')

In [18]: pd.read_hdf('e.h5', 'a')
Out[18]: 
    a   b   c   d   e   f   g
0  21  22  23  24  25  26  27

In [19]: pd.read_hdf('e.h5', 'b')
Out[19]: 
    a   b   c   d   e   f   g
0  21  22  23  24  25  26  27
```

 - to_excel / read_excel

```python
In [21]: e.to_excel('e.xlsx', sheet_name='Sheet1')

In [22]: pd.read_excel('e.xlsx', 'Sheet1', index_col=None, na_values='NA')
Out[22]: 
    a   b   c   d   e   f   g
0  21  22  23  24  25  26  27
```
