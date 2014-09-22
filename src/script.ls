<-! $(document).ready

fs = require \fs
path = require \path

irc = require('slate-irc')
net = require('net')

users = {}
function addUser name
    hue = Math.floor( Math.random! * 360 + 1 )
    color = pusher.color("#2e95c1").hue(hue).hex6()
    users[name] := color


function youtube_parser url
    regExp = /.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?^\s]*).*/
    m = url.match(regExp)
    console.log m
    if m and m[1].length == 11
        return m[1];
    else
        console.log \nope
        return null


stream = net.connect {
  port: 6667,
  host: 'irc.freenode.org'
}

client = irc(stream)

mynick = 'moopmoop'
mychannel = '#reddit-gamedev'

client.pass('pass')
client.nick(mynick)
client.user('tobi', 'Tobi Ferret')

client.join(mychannel)
client.names mychannel, (err, names) ->
    console.log(names)
    for user in names
        addUser user.name

content = $ \#content
chat = $ '#content table'
input = $ \#input


function scrollDown
    $ content .animate { scrollTop: $(content)[0].scrollHeight }, "slow"
    console.log \content_height_ + ($(content)[0].scrollHeight)

function displayMsg msg, author
    # msg = $('<div/>').text(msg).html!  # HACK TO ESCAPE
    youtubeid = youtube_parser(msg)
    console.log \youtubeid_ + youtubeid
    if youtubeid isnt null
        msg += "<iframe type='text/html' width='340' height='240' src='http://www.youtube.com/embed/" + youtubeid + "' frameborder='0'/>"
    tr = $ '<tr><td class="author">' + author + '<div class="square"></div></td><td class="square"><div></div></td><td class="message">' + msg + '</td></tr>'
    chat.append tr
    tr.find '.square div' .css \background-color, users[author]
    scrollDown!

client.on \message (msg) ->
    console.log msg
    displayMsg msg.message, msg.from

client.on \join (event) ->
    console.log event
    addUser event.nick

# chat.append '<tr><td class="author">caribou<div class="square"></div></td><td class="square"><div></div></td><td class="message">Haha how are you?</td></tr>'
# chat.append '<tr><td class="author">Jon<div class="square"></div></td><td class="square"><div></div></td><td class="message">nope!</td></tr>'

input .keypress ->
    if event.which == 13
        client.send mychannel, input.val!
        displayMsg input.val!, mynick
        input.val ""
        
scrollDown!