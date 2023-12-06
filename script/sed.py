# -*- coding: utf-8 -*
# 替换字符串
# python scripts/sed.py filename substr replacement

import sys


def replaceContent(filename, substr, replacement):
  content = ""
  with open(filename) as f:
    content = f.read()

  content = content.replace(substr, replacement)

  with open(filename, 'w') as f:
    f.write(content)


def main():
  filename = sys.argv[1]
  substr = sys.argv[2]
  replacement = sys.argv[3]
  print(filename, substr, replacement)
  replaceContent(filename, substr, replacement)


if __name__ == '__main__':
  main()
