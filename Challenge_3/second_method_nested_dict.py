from deepextract import deepextract
# usage: deepextract.extract_key(obj, key)
print(deepextract.extract_key(({"C": {"B": [{"A":2}]}}, "A")))
#output will be value 2