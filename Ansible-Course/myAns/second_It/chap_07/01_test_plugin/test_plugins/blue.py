
def is_blue(string):
  blue_values = [
    'blue',
    '#0000f',
    '#00f',
    'rgb(0,0,255)',
    'rgb(0%,0%,100%)',
  ]

  if string in blue_values:
    return True
  else:
    return False

class Testmodule(object):
  def tests(self):
    return {
      'blue': is_blue
    }