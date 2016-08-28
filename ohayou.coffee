# Description:
#    script react  if someone says おはよう
# Note:
#

module.exports = (robot) ->
  hello_replies = ['hello','おはよう！','黙れ小僧。','今日も1日がんばってこー！']
  robot.hear /おはよう/i, (res) ->
    res.send res.random hello_replies

