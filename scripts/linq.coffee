# Description:
#   A way to receive and send links to the linqs app
#
# Commands:
#   hubot link me <url> <tags> 
#   hubot grab me <tag> 

_  = require 'underscore'

module.exports = (robot) ->

  formatLinks = (rawLinks)->
    _.reduce rawLinks, (memo, link)->
      "#{memo} \n #{link.title}: #{link.url}"
    , ""

  findLinks = (msg, linkTag) ->
    msg.http("http://localhost:3000/links.json")
      .get() (err, res, body) ->
        results = JSON.parse(body).links;
        rawLinks = _.filter results, (link) ->
          link.title == linkTag
        msg.send formatLinks(rawLinks)

  
  robot.respond /grab( me)? (.*)/i, (msg) ->
    linkTag = msg.match[2]
    findLinks(msg, linkTag)


  robot.respond /(link|l)( me)? (.*)/i, (msg) ->
    urlAndTags = msg.match[3].split(/\s+/)
    url = urlAndTags[0]
    tags = urlAndTags[1]

    newLink = link: {}
    newLink.link = url: url, link_tags_attributes: {}, title: "hubotLink"
    newLink.link.link_tags_attributes = _.map tags.split(/\s+/), (tag) ->
      {tag_attributes: {name: tag}}
                

    user = {user: {email: "rahul@gmail.com", password: "12345678"}}      
    msg.http("http://localhost:3000/users/sign_in")
        .query(user)
        .post() (err, res, body)->
          console.log 'res:', res, 'res.constructor:', res.constructor, 'res.headers:', res.headers, 'res.getHeader:', res.getHeader
          msg.send(res.getHeader("Set-Cookie"))


     

