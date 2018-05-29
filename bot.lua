bot = dofile('./utils.lua')
json = dofile('./JSON.lua')
URL = require "socket.url"
serpent = require("serpent")
http = require "socket.http"
https = require "ssl.https"
redis = require('redis')
tdcli = dofile("tdcli.lua")
database = redis.connect('127.0.0.1', 6379)
BASE = '/home/api/Api/'

local NumberReturn = 12
local color = {
  black = {30, 40},
  red = {31, 41},
  green = {32, 42},
  yellow = {33, 43},
  blue = {34, 44},
  magenta = {35, 45},
  cyan = {36, 46},
  white = {37, 47}
}
----------------------------------------------------------------------------
realm_id = -1001135197265 --Realm ID
----------------------------------------------------------------------------
SUDO = 244252169 --Sudo ID
----------------------------------------------------------------------------
sudo_users = {244252169} --Sudo ID
----------------------------------------------------------------------------
BOTS = 464371613 --Bot ID
----------------------------------------------------------------------------
bot_id = 464371613 --Bot ID
----------------------------------------------------------------------------
botname = 'BLACK'
----------------------------------------------------------------------------
sudoid = '@fiq_king'
----------------------------------------------------------------------------
botuser = '@BrK_1bot'
----------------------------------------------------------------------------
botchannel = '@tv_oof'
----------------------------------------------------------------------------
sudophone = '+9647829374642'
----------------------------------------------------------------------------
pvresan = '@beko_tvbot'
----------------------------------------------------------------------------
supportgp = 'https://telegram.me/joinchat/Do7-CUNlWmQCuS9Qcp9ihw'
----------------------------------------------------------------------------
function vardump(value)
print(serpent.block(value, {comment=false}))
end
----------------------------------------------------------------------------
function dl_cb(arg, data)
end
----------------------------------------------------------------------------
function is_ultrasudo(msg)
local var = false
for k,v in pairs(sudo_users) do
if msg.sender_user_id_ == v then
var = true
end
end
return var
end
----------------------------------------------------------------------------
function is_sudo(msg)
local hash = database:sismember(SUDO..'sudo:',msg.sender_user_id_)
if hash or is_ultrasudo(msg)  then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_bot(msg)
if tonumber(BOTS) == 464371613 then
return true
else
return false
end
end
----------------------------------------------------------------------------
function check_user(msg)
local var = true
if database:get(SUDO.."forcejoin") then
local channel = 't.me/tv_oof'
local url , res = https.request('https://api.telegram.org/bot464371613:AAFhsIv0yzCb4NKf-yfyIzK-L9Me3cAdERA/getchatmember?chat_id='..channel..'&user_id='..msg.sender_user_id_)
data = json:decode(url)
if res ~= 200 or data.result.status == "left" or data.result.status == "kicked" then
var = false
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» لكي يتم عمل البوت يرجى الاشتراك في قناة المطور  ( '..channel..' ) ', 1, 'html')
elseif data.ok then
return var
end
else
return var
end
end
----------------------------------------------------------------------------
function is_founder(msg)
local hash = database:sismember(SUDO..'founders:'..msg.chat_id_,msg.sender_user_id_)
if hash or  is_ultrasudo(msg) or is_sudo(msg) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_owner(msg)
local hash = database:sismember(SUDO..'owners:'..msg.chat_id_,msg.sender_user_id_)
if hash or  is_ultrasudo(msg) or is_sudo(msg) or is_founder(msg) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function sleep(n)
os.execute("sleep " .. tonumber(n))
end
----------------------------------------------------------------------------
function is_mod(msg)
local hash = database:sismember(SUDO..'mods:'..msg.chat_id_,msg.sender_user_id_)
if hash or  is_ultrasudo(msg) or is_sudo(msg) or is_owner(msg) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_vip(msg)
local hash = database:sismember(SUDO..'vips:'..msg.chat_id_,msg.sender_user_id_)
if hash or  is_ultrasudo(msg) or is_sudo(msg) or is_owner(msg) or is_mod(msg) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_banned(chat,user)
local hash =  database:sismember(SUDO..'banned'..chat,user)
if hash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_gban(chat,user)
local hash =  database:sismember(SUDO..'gbaned',user)
if hash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function getUser(user_id, cb)
  tdcli_function ({
ID = "GetUser",
user_id_ = user_id
  }, cb, nil)
end
----------------------------------------------------------------------------
function from_username(msg)
function gfrom_user(extra,result,success)
if result.username_ then
F = result.username_
else F = 'nil' end
return F
end
local username = getUser(msg.sender_user_id_,gfrom_user)
return username
end
----------------------------------------------------------------------------
function resolve_username(username,cb)
tdcli_function ({
ID = "SearchPublicChat",
username_ = username
  }, cb, nil)
end
----------------------------------------------------------------------------
function getUserFull(user_id,cb)
  tdcli_function ({
ID = "GetUserFull",
user_id_ = user_id
  }, cb, nil)
end
----------------------------------------------------------------------------
function deleteMessagesFromUser(chat_id, user_id)
tdcli_function ({
ID = "DeleteMessagesFromUser",
chat_id_ = chat_id,
user_id_ = user_id
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function addChatMember(chat_id, user_id, forward_limit)
tdcli_function ({
ID = "AddChatMember",
chat_id_ = chat_id,
user_id_ = user_id,
forward_limit_ = forward_limit
}, dl_cb, nil)
end
----------------------------------------------------------------------------
local function UpTime()
local uptime = io.popen("uptime -p"):read("*all")
days = uptime:match("up %d+ days")
hours = uptime:match(", %d+ hour") or uptime:match(", %d+ hours")
minutes = uptime:match(", %d+ minutes") or uptime:match(", %d+ minute")
if hours then
hours = hours
else
hours = ""
end
if days then
days = days
else
days = ""
end
if minutes then
minutes = minutes
else
minutes = ""
end
days = days:gsub("up", "")
local a_ = string.match(days, "%d+")
local b_ = string.match(hours, "%d+")
local c_ = string.match(minutes, "%d+")
if a_ then
a = a_
else
a = 0
end
if b_ then
b = b_
else
b = 0
end
if c_ then
c = c_
else
c = 0
end
return a..' days '..b..' hour '..c..' minute'
end
----------------------------------------------------------------------------
function is_filter(msg, value)
local hash = database:smembers(SUDO..'filters:'..msg.chat_id_)
if hash then
local names = database:smembers(SUDO..'filters:'..msg.chat_id_)
local text = ''
for i=1, #names do
if string.match(value:lower(), names[i]:lower()) and not is_mod(msg) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
delete_msg(chat,msgs)
end
end
end
end
----------------------------------------------------------------------------
function is_muted(chat,user)
local hash =  database:sismember(SUDO..'mutes'..chat,user)
if hash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function edit(chat_id, message_id, reply_markup, text, disable_web_page_preview, parse_mode)
  local TextParseMode = getParseMode(parse_mode)
  tdcli_function ({
ID = "EditMessageText",
chat_id_ = chat_id,
message_id_ = message_id,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessageText",
text_ = text,
disable_web_page_preview_ = disable_web_page_preview,
clear_draft_ = 0,
entities_ = {},
parse_mode_ = TextParseMode,
},
  }, dl_cb, nil)
end
----------------------------------------------------------------------------
function pin(channel_id, message_id, disable_notification)
tdcli_function ({
ID = "PinChannelMessage",
channel_id_ = getChatId(channel_id).ID,
message_id_ = message_id,
disable_notification_ = disable_notification
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function unpin(channel_id)
tdcli_function ({
ID = "UnpinChannelMessage",
channel_id_ = getChatId(channel_id).ID
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function pin(channel_id, message_id, disable_notification)
tdcli_function ({
ID = "PinChannelMessage",
channel_id_ = getChatId(channel_id).ID,
message_id_ = message_id,
disable_notification_ = disable_notification
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function SendMetion(chat_id, user_id, msg_id, text, offset, length)
local tt = database:get('endmsg') or ''
tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = msg_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID = "InputMessageText",
text_ = text..'\n\n'..tt,
disable_web_page_preview_ = 1,
clear_draft_ = 0,
entities_ = {[0]={
ID="MessageEntityMentionName",
offset_=offset,
length_=length,
user_id_=user_id
},
},
},
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function resolve_username(username,cb)
  tdcli_function ({
ID = "SearchPublicChat",
username_ = username
  }, cb, nil)
end
---------------------------------------------------------------------------
function del_all_msgs(chat_id, user_id)
  tdcli_function ({
ID = "DeleteMessagesFromUser",
chat_id_ = chat_id,
user_id_ = user_id
  }, dl_cb, nil)
end
----------------------------------------------------------------------------
function priv(chat,user)
local khash = database:sismember(SUDO..'sudo:',user)
local vhash = database:sismember(SUDO..'vips:'..chat,user)
local ohash = database:sismember(SUDO..'owners:'..chat,user)
local mhash = database:sismember(SUDO..'mods:'..chat,user)
if tonumber(SUDO) == tonumber(user) or khash or mhash or ohash or vhash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function getInputFile(file)
local input = tostring(file)
if file:match('/') then
infile = {ID = "InputFileLocal", path_ = file}
elseif file:match('^%d+$') then
infile = {ID = "InputFileId", id_ = file}
else
infile = {ID = "InputFilePersistentId", persistent_id_ = file}
end
return infile
end
----------------------------------------------------------------------------
function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = from_background,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessagePhoto",
photo_ = getInputFile(photo),
added_sticker_file_ids_ = {},
width_ = 0,
height_ = 0,
caption_ = caption
},
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function getChatId(id)
local chat = {}
local id = tostring(id)
if id:match('^-100') then
local channel_id = id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
else
local group_id = id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
end
return chat
end
----------------------------------------------------------------------------
function getChannelMembers(channel_id, offset, filter, limit)
if not limit or limit > 200 then
limit = 200
end
tdcli_function ({
ID = "GetChannelMembers",
channel_id_ = getChatId(channel_id).ID,
filter_ = {
ID = "ChannelMembers" .. filter
},
offset_ = offset,
limit_ = limit
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function adduser(chat_id, user_id, forward_limit)
tdcli_function ({
ID = "AddChatMember",
chat_id_ = chat_id,
user_id_ = user_id,
forward_limit_ = forward_limit or 50
}, dl_cb, nil)
end
----------------------------------------------------------------------------

----------------------------------------------------------------------------
function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id)
  tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = from_background,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessageContact",
contact_ = {
  ID = "Contact",
  phone_number_ = phone_number,
  first_name_ = first_name,
  last_name_ = last_name,
  user_id_ = user_id
},
},
  }, dl_cb, nil)
end
-------------
----------------------------------------------------------------------------
function banall(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, ' تم ', 1, 'md')
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ لا يمكنك حظر   ( المطورين | مدراء البوت ) ', 1, 'md')
else
bot.changeChatMemberStatus(chat, user, "Kicked")
database:sadd(SUDO..'gbaned',user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Successfully Sicked !' , 9, string.len(user)) 
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو ( '..user..' ) تم حضره عام' , 10, string.len(user))
end
end
end
--------------------------------------------------------------------------
local calc = function(exp)
  url = "http://api.mathjs.org/v1/"
  url = url .. "?expr=" .. URL.escape(exp)
  data, res = http.request(url)
  text = nil
  if res == 200 then
    text = data
  elseif res == 400 then
    text = data
  else
    text = "ERR"
  end
  return text
end

----------------------------------------------------------------------------------------------
function kick(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ لا يمكنك طرد  ( المطورين | مدراء المجموعه ) ', 1, 'md')
else
bot.changeChatMemberStatus(chat, user, "Kicked")
end
end
----------------------------------------------------------------------------
function ban(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '😐تم', 1, 'md')
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ لا يمكنك حظر  ( المطورين | مدراء المجموعه ) ', 1, 'md')
else
bot.changeChatMemberStatus(chat, user, "Kicked")
database:sadd(SUDO..'banned'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Successfully Baned !' , 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو ( '..user..' ) تم حضره من المجموعه' , 10, string.len(user))
end
end
end
----------------------------------------------------------------------------
function mute(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'تم 😐', 1, 'md')
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ لا يمكنك كتم  ( المطورين | مدراء المجموعه ) ', 1, 'md')
else
database:sadd(SUDO..'mutes'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*• You Can Not Remove The Ability To Chat In Groups From Other Managers !*', 1, 'md')
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو ( '..user..' ) تم كتمه من المجموعه' , 10, string.len(user))
end
end
end
--------------------------{inline}-------------------------------------------
function edit(message_id, text, keyboard)
	local urlk = url .. "/editMessageText?&inline_message_id=" .. message_id .. "&text=" .. URL.escape(text)
	urlk = urlk .. "&parse_mode=html"
	if keyboard then
		urlk = urlk .. "&reply_markup=" .. URL.escape(json.encode(keyboard))
	end
	return https.request(urlk)
end
function Canswer(callback_query_id, text, show_alert)
	local urlk = url .. "/answerCallbackQuery?callback_query_id=" .. callback_query_id .. "&text=" .. URL.escape(text)
	if show_alert then
		urlk = urlk .. "&show_alert=true"
	end
	https.request(urlk)
end
function answer(inline_query_id, query_id, title, description, text, keyboard)
	local results = {
		{}
	}
	results[1].id = query_id
	results[1].type = "article"
	results[1].description = description
	results[1].title = title
	results[1].message_text = text
	urlk = url .. "/answerInlineQuery?inline_query_id=" .. inline_query_id .. "&results=" .. URL.escape(json.encode(results)) .. "&parse_mode=Markdown&cache_time=" .. 1
	if keyboard then
    results[1].reply_markup = keyboard
    urlk = url .. "/answerInlineQuery?inline_query_id=" .. inline_query_id .. "&results=" .. URL.escape(json.encode(results)) .. "&parse_mode=Markdown&cache_time=" .. 1
  end
  https.request(urlk)
end
---------------------------------------------------------------------------
function getParseMode(parse_mode)
  if parse_mode then
    local mode = parse_mode:lower()

    if mode == 'markdown' or mode == 'md' then
      P = {ID = "TextParseModeMarkdown"}
    elseif mode == 'html' then
      P = {ID = "TextParseModeHTML"}
    end
  end
  return P
end
----------------------------------------------------------------------------
local having_access = function(user_id, chat, Q_id)
  local var = false
  if is_mod(user_id, chat) and is_ReqMenu(user_id, chat) then
    var = true
  end
  if not is_ReqMenu(user_id, chat) and is_mod(user_id, chat) then
    if database:get("lang:gp:" .. chat) then
      Canswer(Q_id, "[•• You Have Not Requested This Menu ••]")
    else
      Canswer(Q_id, "[•• لم تطلب هذه القائمه••]")
    end
  end
  if not is_mod(user_id, chat) then
    if database:get("lang:gp:" .. chat) then
      Canswer(Q_id, "[•• You Do Not Have Access To Make Changes ••]")
    else
      Canswer(Q_id, "[•• لا تستطيع التحكم بالاوامر ••]")
    end
  end
  return var
end
----------------------------------------------------------------------------
function unbanall(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
database:srem(SUDO..'gbaned',user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Successfully UnSicked !' , 9, string.len(user)) 
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو ( '..user..' ) تم الغاء حظر العام عنه' , 10, string.len(user))
end
end
----------------------------------------------------------------------------
function unban(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
database:srem(SUDO..'banned'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Removed From The List Of Baned Users !' , 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو ( '..user..' ) تم الغاء الحظر عنه' , 10, string.len(user))
end
end
----------------------------------------------------------------------------
function unmute(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
database:srem(SUDO..'mutes'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Removed From The Silent List !' , 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو ( '..user..' ) تم الغاء الكتم عنه' , 10, string.len(user))
end
end
----------------------------------------------------------------------------
function delete_msg(chatid,mid)
tdcli_function ({ID="DeleteMessages", chat_id_=chatid, message_ids_=mid}, dl_cb, nil)
end
----------------------------------------------------------------------------
function settings(msg,value,lock) 
local hash = SUDO..'settings:'..msg.chat_id_..':'..value
if value == 'الملفات' then
text = 'الملفات'
elseif value == 'الانلاين' then
text = 'الانلاين'
elseif value == 'الروابط' then
text = 'الروابط'
elseif value == 'الالعاب' then
text = 'الالعاب'
elseif value == 'المعرف' then
text = 'المعرف'
elseif value == 'التاك' then
text = 'التاك'
elseif value == 'التثبيت' then
text = 'التثبيت'
elseif value == 'الصور' then
text = 'الصور'
elseif value == 'المتحركه' then
text = 'المتحركه'
elseif value == 'الفيديو' then
text = 'الفيديو'
elseif value == 'الصوت' then
text = 'الصوت'
elseif value == 'الموسيقى' then
text = 'الموسيقى'
elseif value == 'الدردشه' then
text = 'الدردشه'
elseif value == 'الملصقات' then
text = 'الملصقات'
elseif value == 'الجهات' then
text = 'الجهات'
elseif value == 'التوجيه' then
text = 'التوجيه'
elseif value == 'العربيه' then
text = 'العربيه'
elseif value == 'الانكليزيه' then
text = 'الانكليزيه'
elseif value == 'البوتات' then
text = 'البوتات'
elseif value == 'الاشعارات' then
text = 'الاشعارات'
elseif value == 'الفشار' then
text = 'الفشار'
elseif value == 'بصمه السيلفي' then
text = 'بصمه السيلفي'
elseif value == 'السمايلات' then
text = 'السمايلات'
elseif value == 'الشارحه' then
text = 'الشارحه'
elseif value == 'الاضافه' then
text = 'الاضافه'
elseif value == 'الرد' then
text = 'الرد'
else return false
end
if lock then
database:set(hash,true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ قفل  ( `'..text..'` ) \n •┈•⚜•۪۫•৩﴾ • 🎶 • ﴿৩•۪۫•⚜•┈• \n🚸┇ نشط ',1,'md')
else
database:del(hash)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ قفل ( `'..text..'` ) \n •┈•⚜•۪۫•৩﴾ • 🎶 • ﴿৩•۪۫•⚜•┈• \n🚸┇ معطل  ',1,'md')
end
end
------------------------------------------------------------
function is_lock(msg,value)
local hash = SUDO..'settings:'..msg.chat_id_..':'..value
if database:get(hash) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function warn(msg,chat,user)
local type = database:hget("warn:"..msg.chat_id_,"swarn")
if type == "kick" then
kick(msg,chat,user)
local text = '🚸┇ العضو ( '..user..' ) تم طرده بسبب التحذير '
SendMetion(msg.chat_id_, user, msg.id_, text, 8, string.len(user))
end
if type == "ban" then
local text = '🚸┇ العضو ( '..user..' ) تم حظره بسبب التحذير'
SendMetion(msg.chat_id_, user, msg.id_, text, 8, string.len(user))
changeChatMemberStatus(chat, user, "Kicked")
database:sadd(SUDO..'banned'..chat,user)
end
if type == "mute" then
local text = '🚸┇ العضو ( '..user..' ) تم كتمه بسبب التحذير'
SendMetion(msg.chat_id_, user, msg.id_, text, 8, string.len(user))
database:sadd(SUDO..'mutes'..msg.chat_id_,user)
end
end
----------------------------------------------------------------------------
function trigger_anti_spam(msg,type)
if type == 'kick' then
kick(msg,msg.chat_id_,msg.sender_user_id_)
end
if type == 'ban' then
if is_banned(msg.chat_id_,msg.sender_user_id_) then else
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, 'The User [ '..msg.sender_user_id_..' ] Was Baned From The Group Because Of A Repeated (over-the-message) Message And Its Connection To The Group Was Disconnected.' , 11, string.len(msg.sender_user_id_))
else
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, '🚸┇ العضو ( '..msg.sender_user_id_..' ) تم حظره بسبب التكرار.' , 10, string.len(msg.sender_user_id_))
end
end
bot.changeChatMemberStatus(msg.chat_id_, msg.sender_user_id_, "Kicked")
database:sadd(SUDO..'banned'..msg.chat_id_,msg.sender_user_id_)
end
if type == 'mute' then
if is_muted(msg.chat_id_,msg.sender_user_id_) then else
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, 'User [ '..msg.sender_user_id_..' ]  Was Moved To SilentList Because Of Repeated (over-repeated) Message Sending.' , 7, string.len(msg.sender_user_id_))
else
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, '🚸┇ العضو ( '..msg.sender_user_id_..' )  تم كتمه بسبب التكرار' , 10, string.len(msg.sender_user_id_))
end
end
database:sadd(SUDO..'mutes'..msg.chat_id_,msg.sender_user_id_)
end
end
----------------------------------------------------------------------------
function televardump(msg,value)
local text = json:encode(value)
bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 'html')
end
----------------------------------------------------------------------------
function run(msg,data)
----------------------------------------------------------------------------
if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match('-100(%d+)') then
database:incr(SUDO..'sgpsmessage:')
if not database:sismember(SUDO.."botgps",msg.chat_id_) then
database:sadd(SUDO.."botgps",msg.chat_id_)
end
elseif id:match('^(%d+)') then
database:incr(SUDO..'pvmessage:')
if not database:sismember(SUDO.."usersbot",msg.chat_id_) then
database:sadd(SUDO.."usersbot",msg.chat_id_)
end
else
database:incr(SUDO..'gpsmessage:')
if not database:sismember(SUDO.."botgp",msg.chat_id_) then
database:sadd(SUDO.."botgp",msg.chat_id_)
end
end
end
if msg then
database:incr(SUDO..'groupmsgkk:'..msg.chat_id_..':')
database:incr(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
if msg.send_state_.ID == "MessageIsSuccessfullySent" then
return false
end
end
----------------------------------------------------------------------------
if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match('-100(%d+)') then
chat_type = 'super'
elseif id:match('^(%d+)') then
chat_type = 'user'
else
chat_type = 'group'
end
end
----------------------------------------------------------------------------
local text = msg.content_.text_
local text1 = msg.content_.text_
if text and text:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then
text = text
end
----------------------------------------------------------------------------
if msg.content_.ID == "MessageText" then
msg_type = 'text'
end
if msg.content_.ID == "MessageChatAddMembers" then
msg_type = 'add'
end
if msg.content_.ID == "MessageChatJoinByLink" then
msg_type = 'join'
end
if msg.content_.ID == "MessagePhoto" then
msg_type = 'photo'
end
----------------------------------------------------------------------------
if msg_type == 'text' and text then
if text:match('^[/!]') then
text = text:gsub('^[/!]','')
end
end
----------------------------------------------------------------------------
if text then
if not database:get(SUDO..'bot_id') then
function cb(a,b,c)
database:set(SUDO..'bot_id',b.id_)
end
bot.getMe(cb)
end
end
-------------------------------------------------StartBot-------------------------------------------------
if text == 'start' and not database:get(SUDO.."timeactivee:"..msg.chat_id_) and chat_type == 'user' and check_user(msg) then
function pv_start(extra, result, success)
SendMetion(msg.chat_id_, result.id_, msg.id_, '🚸┇ اهلا  ( '..result.id_..' | '..result.first_name_..' ) \n\nلاستخدام هذا البوت ، ما عليك سوى إضافة هذا الروبوت إلى مجموعتك. \n\n وإدخال الأمر التالي في المجموعة: \n / active \n سيمكّن هذا الأمر تفعيل البوت في مجموعتك \n الرجاء دعم قناة البوت : ✑ '..botchannel..'' , 7, string.len(result.id_))
end
tdcli.getUser(msg.sender_user_id_, pv_start)
database:setex(SUDO.."timeactivee:"..msg.chat_id_, 73200, true)
end
----------------------------------------------------------------------------
if chat_type == 'super' then
local user_id = msg.sender_user_id_
floods = database:hget("flooding:settings:"..msg.chat_id_,"flood") or  'nil'
NUM_MSG_MAX = database:hget("flooding:settings:"..msg.chat_id_,"floodmax") or 5
TIME_CHECK = database:hget("flooding:settings:"..msg.chat_id_,"floodtime") or 5
if database:hget("flooding:settings:"..msg.chat_id_,"flood") then
if not is_mod(msg) then
if msg.content_.ID == "MessageChatAddMembers" then
return
else
local post_count = tonumber(database:get('floodc:'..msg.sender_user_id_..':'..msg.chat_id_) or 0)
if post_count > tonumber(database:hget("flooding:settings:"..msg.chat_id_,"floodmax") or 5) then
local ch = msg.chat_id_
local type = database:hget("flooding:settings:"..msg.chat_id_,"flood")
trigger_anti_spam(msg,type)
end
database:setex('floodc:'..msg.sender_user_id_..':'..msg.chat_id_, tonumber(database:hget("flooding:settings:"..msg.chat_id_,"floodtime") or 3), post_count+1)
end
end
local edit_id = data.text_ or 'nil'
NUM_MSG_MAX = 5
if database:hget("flooding:settings:"..msg.chat_id_,"floodmax") then
NUM_MSG_MAX = database:hget("flooding:settings:"..msg.chat_id_,"floodmax")
end
if database:hget("flooding:settings:"..msg.chat_id_,"floodtime") then
TIME_CHECK = database:hget("flooding:settings:"..msg.chat_id_,"floodtime")
end
end
----------------------------------------------------------------------------
-- save pin message id
if msg.content_.ID == 'MessagePinMessage' then
if is_lock(msg,'pin') and is_owner(msg) then
database:set(SUDO..'pinned'..msg.chat_id_, msg.content_.message_id_)
elseif not is_lock(msg,'pin') then
database:set(SUDO..'pinned'..msg.chat_id_, msg.content_.message_id_)
end
end
----------------------------------------------------------------------------
-- check filters
if text and not is_mod(msg) and not is_vip(msg) then
if is_filter(msg,text) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- check settings
----------------------------------------------------------------------------
-- lock tgservice
if is_lock(msg,'tgservice') then
if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == "MessageChatDeleteMember" then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock pin
if is_owner(msg) then else
if is_lock(msg,'pin') then
if msg.content_.ID == 'MessagePinMessage' then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*🚸┇ التثبيت مقفول لا يمكنك تثبيت رساله اخرى *',1, 'md')
bot.unpinChannelMessage(msg.chat_id_)
local PinnedMessage = database:get(SUDO..'pinned'..msg.chat_id_)
if PinnedMessage then
bot.pinChannelMessage(msg.chat_id_, tonumber(PinnedMessage), 0)
end
end
end
end
----------------------------------------------------------------------------
if database:get(SUDO..'automuteall'..msg.chat_id_)  then
if database:get(SUDO.."automutestart"..msg.chat_id_ ) then
if database:get(SUDO.."automuteend"..msg.chat_id_)  then
local time = os.date("%H%M")
local start = database:get(SUDO.."automutestart"..msg.chat_id_)
local endtime = database:get(SUDO.."automuteend"..msg.chat_id_)
if tonumber(endtime) < tonumber(start) then
if tonumber(time) <= 2359 and tonumber(time) >= tonumber(start) then
if not database:get(SUDO..'muteall'..msg.chat_id_) then
database:set(SUDO..'muteall'..msg.chat_id_,true)
end
elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(endtime) then
if not database:get(SUDO..'muteall'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ حسب قفل الساعة ، يقوم القفل بتأمين المجموعة تلقائيًا \n\n سيؤدي حذف الرسائل إلى حذف رسالتك..', 1, 'md')
database:set(SUDO..'muteall'..msg.chat_id_,true)
end
else
if database:get(SUDO..'muteall'..msg.chat_id_)then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم تعطيل الحذف التلقائي للمجموعة ، ويمكن للمستخدمين نشر محتواهم.', 1, 'md')
database:del(SUDO..'muteall'..msg.chat_id_)
end
end
elseif tonumber(endtime) > tonumber(start) then
if tonumber(time) >= tonumber(start) and tonumber(time) < tonumber(endtime) then
if not database:get(SUDO..'muteall'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ حسب قفل الساعة ، يقوم القفل بتأمين المجموعة تلقائيًا. \n\n سيؤدي حذف الرسائل إلى حذف رسالتك..', 1, 'md')
database:set(SUDO..'muteall'..msg.chat_id_,true)
end
else
if database:get(SUDO..'muteall'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم تعطيل الحذف التلقائي للمجموعة ، ويمكن للمستخدمين نشر محتواهم.', 1, 'md')
database:del(SUDO..'muteall'..msg.chat_id_)
end
end
end
end
end
end
----------------------------------------------------------------------------
if is_vip(msg) then
else
----------------------------------------------------------------------------
-- lock link
if is_lock(msg,'link') then
if text then
if msg.content_.entities_ and msg.content_.entities_[0] and msg.content_.entities_[0].ID == 'MessageEntityUrl' or msg.content_.text_.web_page_ then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or text:match("[Tt].[Mm][Ee]/")
if is_link then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock username
if is_lock(msg,'username') then
if text then
local is_username = text:match("@[%a%d]")
if is_username then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_username = text:match("@[%a%d]")
if is_username then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock hashtag
if is_lock(msg,'tag') then
if text then
local is_hashtag = text:match("#")
if is_hashtag then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_hashtag = text:match("#")
if is_hashtag then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock rep
if is_lock(msg,'reply') then
if msg.reply_to_message_id_ ~= 0 then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock sticker
if is_lock(msg,'sticker') then
if msg.content_.ID == 'MessageSticker' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock join
if is_lock(msg,'join') then
if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" then
bot.changeChatMemberStatus(msg.chat_id_, msg.sender_user_id_, "Kicked")
end
end
----------------------------------------------------------------------------
-- lock forward
if is_lock(msg,'forward') then
if msg.forward_info_ then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock photo
if is_lock(msg,'photo') then
if msg.content_.ID == 'MessagePhoto' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock file
if is_lock(msg,'file') then
if msg.content_.ID == 'MessageDocument' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock file
if is_lock(msg,'inline') then
if msg.reply_markup_ and msg.reply_markup_.ID == 'ReplyMarkupInlineKeyboard' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock game
if is_lock(msg,'game') then
if msg.content_.game_ then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock music
if is_lock(msg,'music') then
if msg.content_.ID == 'MessageAudio' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock voice
if is_lock(msg,'audio') then
if msg.content_.ID == 'MessageVoice' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock gif
if is_lock(msg,'gif') then
if msg.content_.ID == 'MessageAnimation' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock contact
if is_lock(msg,'contact') then
if msg.content_.ID == 'MessageContact' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock video
if is_lock(msg,'video') then
if msg.content_.ID == 'MessageVideo' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock text
if is_lock(msg,'text') then
if msg.content_.ID == 'MessageText' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock arabic
if is_lock(msg,'arabic') then
if text and text:match('[\216-\219][\128-\191]') then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_persian = text:match("[\216-\219][\128-\191]")
if is_persian then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock english
if is_lock(msg,'english') then
if text then
if text:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_english = text:match("[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]")
if is_english then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
end
----------------------------------------------------------------------------
-- lock fosh
if is_lock(msg,'fosh') then
if text then
if text:match("عير") or text:match("کس") or text:match("كس") or text:match("نيجك") or  text:match("كـس") or text:match("نيج") or text:match("زب") or text:match("عيري") or text:match("اكعد علي") or text:match("كوم بي")  or text:match("عيري") or text:match("تنح") or text:match("كسمك") or  text:match("سمك") or text:match("انيج") or text:match("كسختك") or text:match("افركي") or text:match("كـوم بي") or text:match("كحبه") or text:match("كواد") or text:match("سحاقيه") or text:match("نياجك") or text:match("سكسي") or text:match("سکس") or text:match("air") or text:match("kos") or text:match("سكس") or text:match("سحاق") or text:match("عيربختك")  then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end

----------------------------------------------------------------------------
-- lock Tabch
if is_lock(msg,'tabchi') then
if text then
if text:match("احفظ") or text:match("تعال خاص") or text:match("مشتهيه") or text:match("وحدي بالبيت") or  text:match("تعالو خاص") then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end

----------------------------------------------------------------------------
-- lock emoji
if is_lock(msg,'emoji') then
if text then
local is_emoji_msg = text:match("😀") or text:match("😬") or text:match("😁") or text:match("😂") or  text:match("😃") or text:match("😄") or text:match("😅") or text:match("☺️") or text:match("🙃") or text:match("🙂") or text:match("😊") or text:match("😉") or text:match("😇") or text:match("😆") or text:match("😋") or text:match("😌") or text:match("😍") or text:match("😘") or text:match("😗") or text:match("😙") or text:match("😚") or text:match("🤗") or text:match("😎") or text:match("🤓") or text:match("🤑") or text:match("😛") or text:match("😏") or text:match("😶") or text:match("😐") or text:match("😑") or text:match("😒") or text:match("🙄") or text:match("🤔") or text:match("😕") or text:match("😔") or text:match("😡") or text:match("😠") or text:match("😟") or text:match("😞") or text:match("😳") or text:match("🙁") or text:match("☹️") or text:match("😣") or text:match("😖") or text:match("😫") or text:match("😩") or text:match("😤") or text:match("😲") or text:match("😵") or text:match("😭") or text:match("😓") or text:match("😪") or text:match("😥") or text:match("😢") or text:match("🤐") or text:match("😷") or text:match("🤒") or text:match("🤕") or text:match("😴") or text:match("💋") or text:match("❤️")
if is_emoji_msg then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock selfvideo
if is_lock(msg,'selfivideo') then
if msg.content_.ID == "MessageUnsupported" then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock bot
if is_lock(msg,'bot') then
if msg.content_.ID == "MessageChatAddMembers" then
if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
bot.changeChatMemberStatus(msg.chat_id_, msg.content_.members_[0].id_, 'Kicked')
end
end
end
----------------------------------------------------------------------------
-- check mutes
local muteall = database:get(SUDO..'muteall'..msg.chat_id_)
if msg.sender_user_id_ and muteall and not is_mod(msg) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.sender_user_id_ and is_muted(msg.chat_id_,msg.sender_user_id_) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
----------------------------------------------------------------------------
-- check bans
if msg.sender_user_id_ and is_banned(msg.chat_id_,msg.sender_user_id_) then
kick(msg,msg.chat_id_,msg.sender_user_id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and is_banned(msg.chat_id_,msg.content_.members_[0].id_) then
kick(msg,msg.chat_id_,msg.content_.members_[0].id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ العضو محضور من المجموعه.',1, 'md')
end
----------------------------------------------------------------------------
--check Gbans
if msg.sender_user_id_ and is_gban(msg.chat_id_,msg.sender_user_id_) then
kick(msg,msg.chat_id_,msg.sender_user_id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and is_gban(msg.chat_id_,msg.content_.members_[0].id_) then
kick(msg,msg.chat_id_,msg.content_.members_[0].id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
----------------------------------------------------------------------------
if is_lock(msg,'cmd') then
if not is_mod(msg) then
return  false
end
end
end
----------------------------------------------------------------------------
-- welcome
local status_welcome = (database:get(SUDO..'status:welcome:'..msg.chat_id_) or 'disable')
if status_welcome == 'enable' then
if msg.content_.ID == "MessageChatJoinByLink" then
if not is_banned(msg.chat_id_,msg.sender_user_id_) then
function wlc(extra,result,success)
if database:get(SUDO..'welcome:'..msg.chat_id_) then
t = database:get(SUDO..'welcome:'..msg.chat_id_)
else
t = '📮┇ اهلا عزيزي : {name}\n 🚸┇ نورت المجموعه'
end
local t = t:gsub('{name}',result.first_name_)
bot.sendMessage(msg.chat_id_, msg.id_, 1, t,0)
end
bot.getUser(msg.sender_user_id_,wlc)
end
end
if msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].type_.ID == 'UserTypeGeneral' then
if msg.content_.ID == "MessageChatAddMembers" then
if not is_banned(msg.chat_id_,msg.content_.members_[0].id_) then
if database:get(SUDO..'welcome:'..msg.chat_id_) then
t = database:get(SUDO..'welcome:'..msg.chat_id_)
else
t = '📮┇ اهلا عزيزي : {name}\n 🚸┇ نورت المجموعه'
end
local t = t:gsub('{name}',msg.content_.members_[0].first_name_)
bot.sendMessage(msg.chat_id_, msg.id_, 1, t,0)
end
end
end
end
----------------------------------------------------------------------------
-- locks
if text and is_owner(msg) then
local lock = text:match('^قفل التثبيت$')
local unlock = text:match('^فتح التثبيت$')
if lock then
settings(msg,'pin','lock')
end
if unlock then
settings(msg,'pin')
end
end
if text and is_mod(msg) then
local lock = text:match('^lock (.*)$') or text:match('^قفل (.*)$')
local unlock = text:match('^unlock (.*)$') or text:match('^فتح (.*)$')
local pin = text:match('^lock pin$') or text:match('^unlock pin$')
if pin and is_mod(msg) then
elseif pin and not is_mod(msg) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ هذا الامر للادمنيه فقط',1, 'md')
elseif lock then
settings(msg,lock,'lock')
elseif unlock then
settings(msg,unlock)
end
end
----------------------------------------------------------------------------
-- lock flood settings
if text and is_owner(msg) then
if text == 'قفل التكرار بالطرد' then
database:hset("flooding:settings:"..msg.chat_id_ ,"flood",'kick')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Activation Repeatedly!*\n*Status :* [ `Kick User` ]',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم قفل التكرار بالطرد.',1, 'md')
end
elseif text == 'قفل التكرار بالحظر' then
database:hset("flooding:settings:"..msg.chat_id_ ,"flood",'ban')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Activation Repeatedly!*\n*Status :* [ `Ban User` ]',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم قفل التكرار بالحظر.',1, 'md')
end
elseif text == 'قفل التكرار بالكتم' then
database:hset("flooding:settings:"..msg.chat_id_ ,"flood",'mute')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Activation Repeatedly!*\n*Status :* [ `Mute User` ]',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم قفل التكرار بالكتم.',1, 'md')
end
elseif text == 'فتح التكرار' then
database:hdel("flooding:settings:"..msg.chat_id_ ,"flood")
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Sending Has Been Disabled Repeatedly!*',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم فتح التكرار بجميع انواعه.',1, 'md')
end
end
end
----------------------------------------------------------------------------
database:incr(SUDO.."allmsg")
if msg.content_.game_ then
print("------ G A M E ------")
elseif msg.content_.text_ then
print("------ T E X T ------")
elseif msg.content_.sticker_ then
print("------ S T I C K E R ------")
elseif msg.content_.animation_ then
print("------ G I F ------")
elseif msg.content_.voice_ then
print("------ V O I C E ------")
elseif msg.content_.video_ then
print("------ V I D E O ------")
elseif msg.content_.photo_ then
print("------ P H O T O ------")
elseif msg.content_.document_ then
print("------ D O C U M E N T ------")
elseif msg.content_.audio_  then
print("------ A U D I O ------")
elseif msg.content_.location_ then
print("------ L O C A T I O N ------")
elseif msg.content_.contact_ then
print("------ C O N T A C T ------")
end
----------------------------------------------------------------------------
if not database:get(SUDO.."timeclears:") then
io.popen("rm -rf ~/.telegram-cli/data/sticker/*")
io.popen("rm -rf ~/.telegram-cli/data/photo/*")
io.popen("rm -rf ~/.telegram-cli/data/animation/*")
io.popen("rm -rf ~/.telegram-cli/data/video/*")
io.popen("rm -rf ~/.telegram-cli/data/audio/*")
io.popen("rm -rf ~/.telegram-cli/data/voice/*")
io.popen("rm -rf ~/.telegram-cli/data/temp/*")
io.popen("rm -rf ~/.telegram-cli/data/thumb/*")
io.popen("rm -rf ~/.telegram-cli/data/document/*")
io.popen("rm -rf ~/.telegram-cli/data/profile_photo/*")
io.popen("rm -rf ~/.telegram-cli/data/encrypted/*")
database:setex(SUDO.."timeclears:", 7200, true)
bot.sendMessage(realm_id, 0, 1, '🔖┇ يتم مسح جميع البيانات ع السيرفر', 1, 'md')
print("------ All Cache Has Been Cleared ------")
end
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Ultrasudo
if text then
----------------------------------------------------------------------------
if is_ultrasudo(msg) then
----------------------------------------------------------------------------
if text:match("^[Tt][Aa][Gg]$") then
local function GetCreator(extra, result, success)
rank = '#TAG\n\n'
for p , t in pairs(result.members_) do
local function Mehdi(y , vahid)
if vahid.username_ then
user_name = '@'..vahid.username_
else
user_name = t.user_id_
end
rank_ = rank..''..user_name..' , '
end
tdcli.getUser(t.user_id_, Mehdi)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, rank_, 1, 'md')
end
bot.getChannelMembers(msg.chat_id_, 0, 'Recent', 200, GetCreator)
end
----------------------------------------------------------------------------
if text and text:match("^[lL][uU][aA] (.*)") and is_ultrasudo(msg) then
local text = text:match("^[lL][uU][aA] (.*)")
local output = loadstring(text)()
if output == nil then
output = ""
elseif type(output) == "table" then
output = serpent.block(output, {comment = false})
else
utput = "" .. tostring(output)
end
bot.sendMessage(msg.chat_id_, msg.sender_user_id_, 1,output, 1, 'html')
end
----------------------------------------------------------------------------
if text == 'join on' then
if not database:get(SUDO.."forcejoin") then
database:set(SUDO.."forcejoin", true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری روشن شد.", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری روشن بود.", 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'join off' then
if database:get(SUDO.."forcejoin") then
database:del(SUDO.."forcejoin")
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری خاموش شد.", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری خاموش بود.", 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'اذاعه' then
function Broad(extra, result)
local txt = result.content_.text_
local list = database:smembers(SUDO.."botgps") or 0
for k,v in pairs(list) do
tdcli.sendText(v, 0, 0, 1, nil, txt, 1, 'md')
end
local kos = database:smembers(SUDO.."botgp") or 0
for k,v in pairs(kos) do
tdcli.sendText(v, 0, 0, 1, nil, txt, 1, 'md')
end
local kr = database:smembers(SUDO.."usersbot") or 0
for k,v in pairs(kr) do
tdcli.sendText(v, 0, 0, 1, nil, txt, 1, 'md')
end
tdcli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, '🚸┇ تم اذاعه الرساله', 1, 'md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),Broad)
end
end
----------------------------------------------------------------------------
if text:match("^توجيه (.*)") and msg.reply_to_message_id_ ~= 0 then
local action = text:match("^توجيه (.*)")
if action == "كروبات سوبر" then
local gp = database:smembers(SUDO.."botgps") or 0
local gps = database:scard(SUDO.."botgps") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم توجيه الرساله الى '..gps..'كروب سوبر', 1, 'md')
elseif action == "كروبات" then
local gp = database:smembers(SUDO.."botgp") or 0
local gps = database:scard(SUDO.."botgp") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم توجيه الرساله الى '..gps..' كروب', 1, 'md')
elseif action == "خاص" then
local gp = database:smembers(SUDO.."usersbot") or 0
local gps = database:scard(SUDO.."usersbot") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم توجيه الرساله الى '..gps..' کاربر فوروارد شد.', 1, 'md')
elseif action == "الكل" then
local gp = database:smembers(SUDO.."usersbot") or 0
local gpspv = database:scard(SUDO.."usersbot") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
local gp = database:smembers(SUDO.."botgps") or 0
local gpss = database:scard(SUDO.."botgps") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
local gp = database:smembers(SUDO.."botgp") or 0
local gps = database:scard(SUDO.."botgp") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم توجيه الرساله الى '..gpss..' كروب سوبر , '..gps..' كروب '..gpspv..' عضو على الخاص', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'جلب الملف' then
tdcli.sendDocument(SUDO, 0, 0, 1, nil, './bot.lua', dl_cb, nil)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ اخر تحديث للملف ', 1, 'md')
end
----------------------------------------------------------------------------
if text == 'رفع مطور' then
function prom_reply(extra, result, success)
database:sadd(SUDO..'sudo:',result.sender_user_id_)
local user = result.sender_user_id_
local text = '🚸┇ العضو ( '..user..' ) تم رفعه مطور '
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text == 'تنزيل مطور' then
function prom_reply(extra, result, success)
database:srem(SUDO..'sudo:',result.sender_user_id_)
local text = '🚸┇ العضو ( '..result.sender_user_id_..' ) تم تنزيله من المطورين'
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, text, 10, string.len(result.sender_user_id_))
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text == 'حظر عام' then
if msg.reply_to_message_id_ == 0 then
local user = msg.sender_user_id_
else
function banreply(extra, result, success)
banall(msg,msg.chat_id_,result.sender_user_id_)
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),banreply)
end
----------------------------------------------------------------------------
if text:match('^حظر عام (%d+)') then
banall(msg,msg.chat_id_,text:match('حظر عام (%d+)'))
end
----------------------------------------------------------------------------
if text == 'الغاء عام' then
if msg.reply_to_message_id_ == 0 then
local user = msg.sender_user_id_
else
function unbanreply(extra, result, success)
unbanall(msg,msg.chat_id_,result.sender_user_id_)
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply)
end
----------------------------------------------------------------------------
if text:match('^الغاء عام (%d+)') then
unbanall(msg,msg.chat_id_,text:match('الغاء عام (%d+)'))
end
----------------------------------------------------------------------------
if text == 'تحديث' then
database:del(SUDO.."allmsg")
database:del(SUDO.."botgps")
database:del(SUDO.."botgp")
database:del(SUDO.."usersbot")
database:del(SUDO..'sgpsmessage:')
database:del(SUDO..'gpsmessage:')
database:del(SUDO..'pvmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ تم تحديث معلومات البوت.', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^تحديث السوبر$') and is_ultrasudo(msg) then
database:del(SUDO.."botgps")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ تم تحديث معلومات المجموعات السوبر !', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^تحديث الكروبات$') and is_ultrasudo(msg) then
database:del(SUDO.."botgp")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ تم تحديث الكروبات', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^تحديث الخاص$') and is_ultrasudo(msg) then
database:del(SUDO.."usersbot")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ تم تحديث الخاص', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^تحديث الكل$') and is_ultrasudo(msg) then
database:del(SUDO.."allmsg")
database:del(SUDO..'sgpsmessage:')
database:del(SUDO..'gpsmessage:')
database:del(SUDO..'pvmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ تم تحديث رسائل الكل', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^تحديث رسائل السوبر$') and is_ultrasudo(msg) then
database:del(SUDO..'sgpsmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» تم تحديث رسائل السوبر', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^تحديث رسائل الكروبات$') and is_ultrasudo(msg) then
database:del(SUDO..'gpsmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ تم تحديث رسائل الكروبات', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^تحديث رسائل الخاص$') and is_ultrasudo(msg) then
database:del(SUDO..'pvmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ تم تحديث رسائل الخاص !', 1, 'html')
end
----------------------------------------------------------------------------
if text == 'serverinfo' or text == 'معلومات السيرفر' then
local cpu = io.popen("lscpu"):read("*all")
local ram = io.popen("free -m"):read("*all")
local uptime = io.popen("uptime"):read("*all")
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ معلومات سيرفر البوت الخاص بك :\n\n⇜ ram info :\n `'..ram..'` \n\n\n⇜ cpu usage :\n `'..cpu..'` \n\n\n⇜ uptime :\n `'..uptime..'` \n⇜  ', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🔖┇ معلومات السيرفر  :\n\n⇜  رام : \n\n\n `'..ram..'` \n⇜ مساحه : \n\n\n `'..cpu..'` \n\n⇜ وقت عمل السيرفر :\n `'..uptime..'` \n', 1, 'md')
end
end
----------------------------------------------------------------------------
end -- end is_ultrasudo msg
----------------------------------------------------------------------------
if is_sudo(msg) then
----------------------------------------------------------------------------
if text == 'غادر بوت' then
bot.changeChatMemberStatus(msg.chat_id_, bot_id, "Left")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم حذف جميع بيانات المجموعه', 1, 'md')
end
----------------------------------------------------------------------------
if text == 'رفع منشئ' then
function prom_reply(extra, result, success)
database:sadd(SUDO..'founders:'..msg.chat_id_,result.sender_user_id_)
local user = result.sender_user_id_
local text = '🚸┇ العضو ( '..user..' ) تم رفعه منشئ المجموعه '
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^رفع منشئ  (%d+)') then
local user = text:match('رفع منشئ (%d+)')
database:sadd(SUDO..'founders:'..msg.chat_id_,user)
local text = '🚸┇ العضو ( '..user..' )  تم رفعه منشئ للمجموعه '
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
----------------------------------------------------------------------------
if text == 'تنزيل منشئ' then
function prom_reply(extra, result, success)
database:srem(SUDO..'founders:'..msg.chat_id_,result.sender_user_id_)
local text = '🚸┇ العضو ( '..result.sender_user_id_..' ) تم تنزيله من منشئين المجموعه '
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, text, 10, string.len(result.sender_user_id_))
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^تنزيل منشئ (%d+)') then
local user = text:match('منشئ مدير (%d+)')
database:srem(SUDO..'owners:'..msg.chat_id_,user)
local text = '🚸┇ العضو ( '..user..' ) تم تنزيله من منشئين المجموعه'
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
----------------------------------------------------------------------------
if text == 'مسح المنشئين' then
database:del(SUDO..'founders:'..msg.chat_id_)
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم مسح قائمه المنشئين.', 1, 'md')
end
----------------------------------------------------------------------------
if text == 'رفع مدير' then
function prom_reply(extra, result, success)
database:sadd(SUDO..'owners:'..msg.chat_id_,result.sender_user_id_)
local user = result.sender_user_id_
local text = '🚸┇ العضو ( '..user..' ) تم رفعه مدير '
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^رفع مدير  (%d+)') then
local user = text:match('رفع مدير (%d+)')
database:sadd(SUDO..'owners:'..msg.chat_id_,user)
local text = '🚸┇ العضو ( '..user..' )  تم رفعه مدير '
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
----------------------------------------------------------------------------
if text == 'تنزيل مدير' then
function prom_reply(extra, result, success)
database:srem(SUDO..'owners:'..msg.chat_id_,result.sender_user_id_)
local text = '🚸┇ العضو ( '..result.sender_user_id_..' ) تم تنزيله من اداره المجموعه '
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, text, 10, string.len(result.sender_user_id_))
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^تنزيل مدير (%d+)') then
local user = text:match('تنزيل مدير (%d+)')
database:srem(SUDO..'owners:'..msg.chat_id_,user)
local text = '🚸┇ العضو ( '..user..' ) تم تنزيله من اداره المجموعه'
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
----------------------------------------------------------------------------
if text == 'مسح المدراء' then
database:del(SUDO..'owners:'..msg.chat_id_)
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم مسح قائمه المدراء.', 1, 'md')
end
----------------------------------------------------------------------------
if text == 'reload' or text == 'تحديث البوت' then
dofile('bot.lua')
io.popen("rm -rf ~/.telegram-cli/data/animation/*")
io.popen("rm -rf ~/.telegram-cli/data/audio/*")
io.popen("rm -rf ~/.telegram-cli/data/document/*")
io.popen("rm -rf ~/.telegram-cli/data/photo/*")
io.popen("rm -rf ~/.telegram-cli/data/sticker/*")
io.popen("rm -rf ~/.telegram-cli/data/temp/*")
io.popen("rm -rf ~/.telegram-cli/data/thumb/*")
io.popen("rm -rf ~/.telegram-cli/data/video/*")
io.popen("rm -rf ~/.telegram-cli/data/voice/*")
io.popen("rm -rf ~/.telegram-cli/data/profile_photo/*")
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'Done :)', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇تم تحديث البوت ', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'stats' or text == 'الاحصائيات' then
local users = database:scard(SUDO.."usersbot") or 0
local sgpsm = database:get(SUDO..'sgpsmessage:') or 0
local gpsm = database:get(SUDO..'gpsmessage:') or 0
local pvm = database:get(SUDO..'pvmessage:') or 0
local gp = database:scard(SUDO.."botgp") or 0
local gps = database:scard(SUDO.."botgps") or 0
local allmgs = database:get(SUDO.."allmsg") or 0
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ احصائيات البوت :\n\n🏅┇ الكروبات : [ `'..gp..'` ]\n🗂┇ عدد رسائل الكروبات : [ `'..gpsm..'` ]\n\n🎖┇ الكروبات السوبر : [ `'..gps..'` ]\n🗂┇ رسائل كروبات السوبر : [ `'..sgpsm..'` ]\n\n🕴┇ الاعضاء : [ `'..users..'` ]\n🗂┇ رسائل الاعضاء : [ `'..pvm..'` ]\n\n🗂┇ عدد جميع الرسائل : [ `'..allmgs..'` ]\n\n ', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ احصائيات البوت :\n\n🏅┇ الكروبات : [ `'..gp..'` ]\n🗂┇ عدد رسائل الكروبات : [ `'..gpsm..'` ]\n\n🎖┇ الكروبات السوبر : [ `'..gps..'` ]\n🗂┇ رسائل كروبات السوبر : [ `'..sgpsm..'` ]\n\n🕴┇ الاعضاء : [ `'..users..'` ]\n🗂┇ رسائل الاعضاء : [ `'..pvm..'` ]\n\n🗂┇ عدد جميع الرسائل : [ `'..allmgs..'` ]\n\n ', 1, 'md')

end
end
----------------------------------------------------------------------------
end -- end is_sudo msg
----------------------------------------------------------------------------
-- owner
if is_owner(msg) then
----------------------------------------------------------------------------
if text:match("^[Ss]etlang (.*)$") or text:match("^اللغه (.*)$") then
local langs = {string.match(text, "^(.*) (.*)$")}
if langs[2] == "ar" or langs[2] == "عربي" then
if not database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '📮┇ اللغه عربيه بالفعل !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '📮┇ تم وضع اللغه عربي ! ', 1, 'md')
database:del('lang:gp:'..msg.chat_id_)
end
end
if langs[2] == "en" or langs[2] == "انكليزيه" then
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '📮┇ Language Bot is *already* English', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '📮┇ Language Bot has been changed to *English* !', 1, 'md')
database:set('lang:gp:'..msg.chat_id_,true)
end
end
end
----------------------------------------------------------------------------
if text == 'config' or text == 'رفع الادمنيه' then
local function promote_admin(extra, result, success)
vardump(result)
local chat_id = msg.chat_id_
local admins = result.members_
for i=1 , #admins do
if database:sismember(SUDO..'mods:'..msg.chat_id_,admins[i].user_id_) then
else
database:sadd(SUDO..'mods:'..msg.chat_id_,admins[i].user_id_)
end
end
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• All Admins Have Been Successfully Promoted !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ تم رفع جميع الادمنيه .', 1, 'md')
end
end
bot.getChannelMembers(msg.chat_id_, 0, 'Administrators', 200, promote_admin)
end
----------------------------------------------------------------------------
if text == 'clean bots' or text == 'مسح البوتات' then
local function cb(extra,result,success)
local bots = result.members_
for i=0 , #bots do
kick(msg,msg.chat_id_,bots[i].user_id_)
end
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• All Api Robots Were Kicked !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم طرد جميع بوتات الـ (Api)🤖 .', 1, 'md')
end
end
bot.channel_get_bots(msg.chat_id_,cb)
end
----------------------------------------------------------------------------
if text and text:match('^setlink (.*)') or text:match('^وضع رابط (.*)') then
local link = text:match('^setlink (.*)') or text:match('^وضع رابط (.*)')
database:set(SUDO..'grouplink'..msg.chat_id_, link)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• The New Link Was Successfully Saved And Changed !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇ تم وضع الرابط.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'remlink' or text == 'مسح الرابط' then
database:del(SUDO..'grouplink'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• The Link Was Successfully Deleted !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇ تم حذف الرابط المحفوض.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'remrules' or text == 'مسح القوانين' then
database:del(SUDO..'grouprules'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Group Rules Have Been Successfully Deleted !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇تم مسح القوانين.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^setrules (.*)') or text:match('^وضع قوانين (.*)') then
link = text:match('^setrules (.*)') or text:match('^وضع قوانین (.*)')
database:set(SUDO..'grouprules'..msg.chat_id_, link)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Group Rules Were Successfully Registered !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇ تم وضع القوانين.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'welcome enable' or text == 'تفعيل الترحيب' then
database:set(SUDO..'status:welcome:'..msg.chat_id_,'enable')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Welcome Message Was Activated !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇ تم تفعيل الترحيب', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'welcome disable' or text == 'تعطيل الترحيب' then
database:set(SUDO..'status:welcome:'..msg.chat_id_,'disable')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Sending Welcome Message Has Been Disabled !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇ تم تعطيل الترحيب ', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^setwelcome (.*)$') or text:match('^وضع ترحيب (.*)$') then
local welcome = text:match('^setwelcome (.*)$') or text:match('^وضع ترحيب (.*)$')
database:set(SUDO..'welcome:'..msg.chat_id_,welcome)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'<b>Welcome Message Was Successfully Saved And Changed</b>\n<b>Welcome Message Text :</b>\n{ '..welcome..' }', 1, 'html')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇ تم وضع ترحيب\n{ '..welcome..' }', 1, 'html')
end
end
----------------------------------------------------------------------------
if text == 'rem welcome' or text == 'حذف الترحيب' then
database:del(SUDO..'welcome:'..msg.chat_id_,welcome)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• The Welcome Message Was Reset And Set To Default !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🔖┇ تم حذف الترحيب', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'ownerlist' or text == 'المنشئين' then
local list = database:smembers(SUDO..'founders:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '↫ founderlist :\n\n'
else
t = '🚸┇ منشئين المجموعه :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - [ "..v.." ]\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '_The List Of founder Of The Group Is Empty_ !'
else
t = '🚸┇ لا يوجد منشئين في المجموعه .'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'ownerlist' or text == 'المدراء' then
local list = database:smembers(SUDO..'owners:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '🚸┇ ownerlist :\n\n'
else
t = '🚸┇ مدراء المجموعه :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `[ "..v.." ]`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '_🚸┇ The List Of Owners Of The Group Is Empty_ !'
else
t = '🚸┇ لا يوجد مدراء في المجموعه .'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'promote' or text == 'رفع ادمن' then
function prom_reply(extra, result, success)
database:sadd(SUDO..'mods:'..msg.chat_id_,result.sender_user_id_)
local user = result.sender_user_id_
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Promote List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو  ( '..user..' ) تم رفعه ادمن للمجموعه', 11, string.len(user))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^promote (%d+)') or text:match('^رفع ادمن (%d+)') then
user = text:match('promote (%d+)') or text:match('^رفع ادمن (%d+)')
database:sadd(SUDO..'mods:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Promote List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو  ( '..user..' ) تم رفعه ادمن للمجموعه', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'demote' or text == 'تنزيل ادمن' then
function prom_reply(extra, result, success)
database:srem(SUDO..'mods:'..msg.chat_id_,result.sender_user_id_)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '• User [ '..result.sender_user_id_..' ] Was Removed From The Group Promote List !', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '🚸┇ العضو  ( '..result.sender_user_id_..' ) تم تنزيله من ادمنيه المجموعه', 11, string.len(result.sender_user_id_))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^demote (%d+)') or text:match('^تنزيل ادمن (%d+)') then
local user = text:match('demote (%d+)') or text:match('^تنزيل ادمن (%d+)')
database:srem(SUDO..'mods:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Removed From The Group Promote List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو  ( '..user..' ) تم تنزيله من ادمنيه المجموعه', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'modlist' or text == 'الادمنيه' then
local list = database:smembers(SUDO..'mods:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
local t = '🚸┇ modlist :\n\n'
else
local t = '🚸┇ ادمنيه المجموعه :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '_🚸┇ The List Of Mods Of The Group Is Empty_ !'
else
t = '🚸┇ لا يوجد ادمنيه.'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'clean modlist' or text == 'مسح الادمنيه' then
database:del(SUDO..'mods:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'Modlist has been cleaned!', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم مسح قائمه الادمنيه', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'setvip' or text == 'رفع عضو مميز' then
function vip(extra, result, success)
database:sadd(SUDO..'vips:'..msg.chat_id_,result.sender_user_id_)
local user = result.sender_user_id_
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Vip List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو  ( '..user..' ) تم وضعه عضو مميز .', 11, string.len(user))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),vip)
end
end
----------------------------------------------------------------------------
if text and text:match('^setvip (%d+)') or text:match('^رفع عضو مميز (%d+)') then
local user = text:match('setvip (%d+)') or text:match('^رفع عضو مميز (%d+)')
database:sadd(SUDO..'vips:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Vip List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو  ( '..user..' ) تم رفع عضو مميز.', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'remvip' or text == 'تنزيل عضو مميز' then
function MrPokerWkoni(extra, result, success)
database:srem(SUDO..'vips:'..msg.chat_id_,result.sender_user_id_)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '• User [ '..result.sender_user_id_..' ]  ] Was Removed From The Group Vip List !', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '🚸┇ العضو  ( '..result.sender_user_id_..' ) تم تنزيله من الاعضاء المميزين.', 11, string.len(result.sender_user_id_))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MrPokerWkoni)
end
end
----------------------------------------------------------------------------
if text and text:match('^remvip (%d+)') or text:match('^تنزيل عضو مميز (%d+)') then
local user = text:match('remvip (%d+)') or text:match('^تنزيل عضو مميز (%d+)')
database:srem(SUDO..'vips:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ]  ] Was Removed From The Group Vip List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '🚸┇ العضو  ( '..user..' ) تم تنزيله من الاعضاء المميزين', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'viplist' or text == 'الاعضاء المميزين' then
local list = database:smembers(SUDO..'vips:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '🚸┇ viplist :\n\n'
else
t = '🚸┇ الاعضاء المميزين :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '_🚸┇ The List Of vips Of The Group Is Empty_ !'
else
t = '🚸┇ لايوجد اعضاء مميزين .'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'clean viplist' or text == 'مسح المميزين' then
database:del(SUDO..'vips:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇Viplist has been cleaned!', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم مسح الاعضاء المميزين.', 1, 'md')
end
end
----------------------------------------------------------------------------
end -- end is_owner msg
----------------------------------------------------------------------------
-- mods
if is_mod(msg) then

----------------------------------------------------------------------------
if text and text:match('^warnmax (%d+)') or text:match('^وضع تحذير (%d+)') then
local num = text:match('^warnmax (%d+)') or text:match('^وضع تحذير (%d+)')
if 2 > tonumber(num) or tonumber(num) > 10 then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ يجب تحديد عدد من الـ 2 الى 10', 1, 'md')
else
database:hset("warn:"..msg.chat_id_ ,"warnmax" ,num)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'warn has been set to [ '..num..' ] number', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم وضع عدد التكرار ( '..num..' ) ', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if text == 'التحذير بالطرد' then
database:hset("warn:"..msg.chat_id_ ,"swarn",'kick')
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ تم وضع لتحذير بالطرد', 1, 'html')
elseif text == 'التحذير بالحظر' then
database:hset("warn:"..msg.chat_id_ ,"swarn",'ban')
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ تم وضع التحذير بالحظر', 1, 'html')
elseif text == 'التحذير بالكتم' then
database:hset("warn:"..msg.chat_id_ ,"swarn",'mute')
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ تم وضع التحذير بالكتم', 1, 'html')
end
----------------------------------------------------------------------------
if (text == 'warn' or text == 'التحذير') and tonumber(msg.reply_to_message_id_) > 0 then
function warn_by_reply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'حسنا', 1, 'md')
return false
end
if priv(msg.chat_id_,result.sender_user_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لايمكن تحذير  ( المطورين | مدراء المجموعات )  !', 1, 'md')
else
local nwarn = tonumber(database:hget("warn:"..result.chat_id_,result.sender_user_id_) or 0)
local wmax = tonumber(database:hget("warn:"..result.chat_id_ ,"warnmax") or 3)
if nwarn == wmax then
database:hset("warn:"..result.chat_id_,result.sender_user_id_,0)
warn(msg,msg.chat_id_,result.sender_user_id_)
else
database:hset("warn:"..result.chat_id_,result.sender_user_id_,nwarn + 1)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'warn has been set to [ '..num..' ] number', 1, 'md')
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ User ( '..result.sender_user_id_..' )  Due to non-observance of the rules, you received a warning from the robot management regarding the number of your warns :  '..(nwarn + 1)..'/'..wmax..'', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '🚸┇ العضو ( '..result.sender_user_id_..' )  بسبب تحذيراتك تم  :  '..(nwarn + 1)..'/'..wmax..'', 10, string.len(result.sender_user_id_))
end
end
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),warn_by_reply)
end
----------------------------------------------------------------------------
if (text == 'unwarn' or text == 'الغاء التحذير') and tonumber(msg.reply_to_message_id_) > 0 then
function unwarn_by_reply(extra, result, success)
if priv(msg.chat_id_,result.sender_user_id_) then
else
if not database:hget("warn:"..result.chat_id_,result.sender_user_id_) then
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '🚸┇ User ( '..result.sender_user_id_..' ) has not received any warns', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '🚸┇ العضو ( '..result.sender_user_id_..' ) لا يوجد تحذير عليه', 10, string.len(result.sender_user_id_))
end
local warnhash = database:hget("warn:"..result.chat_id_,result.sender_user_id_)
else database:hdel("warn:"..result.chat_id_,result.sender_user_id_,0)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ user ( '..result.sender_user_id_..' ) cleared all his warnings.', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '🚸┇ العضو ( '..result.sender_user_id_..' ) تم مسح جميع تحذيراته', 10, string.len(result.sender_user_id_))
end
end
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unwarn_by_reply)
end
----------------------------------------------------------------------------
local function getsettings(value)
if value == 'muteall' then
local hash = database:get(SUDO..'muteall'..msg.chat_id_)
if hash then
return '(  ✓ )'
else
return '(  ✘ )'
end
elseif value == 'welcome' then
local hash = database:get(SUDO..'welcome:'..msg.chat_id_)
if hash == 'enable' then
return '(  ✓ )'
else
return '(  ✘ )'
end
elseif value == 'spam' then
local hash = database:hget("flooding:settings:"..msg.chat_id_,"flood")
if hash then
if database:hget("flooding:settings:"..msg.chat_id_, "flood") == "kick" then
return '( فعال - بالطرد )'
elseif database:hget("flooding:settings:"..msg.chat_id_,"flood") == "ban" then
return '( فعال - بالحظر )'
elseif database:hget("flooding:settings:"..msg.chat_id_,"flood") == "mute" then
return '( فعال - بالكتم )'
end
else
return '(  ✘ )'
end
elseif is_lock(msg,value) then
return  '(  ✓ )'
else
return '(  ✘ )'
end
end
----------------------------------------------------------------------------
if text == 'settings' or text == 'الاعدادات' then
local wmax = tonumber(database:hget("warn:"..msg.chat_id_ ,"warnmax") or 3)
local text = '🚸┇ اعدادات المجموعه :\n\n'
..'⇜ قفل الروابط : '..getsettings('links')..'\n'
..'⇜ قفل البوتات : '..getsettings('bot')..'\n'
..'⇜ قفل التاك : '..getsettings('tag')..'\n'
..'⇜ قفل السبام : '..getsettings('spam')..'\n'
..'⇜ قفل المعرف : '..getsettings('username')..'\n'
..'⇜ قفل التوجيه : '..getsettings('forward')..'\n'
..'⇜ عدد التكرار : [ '..NUM_MSG_MAX..' ]\n'
..'⇜ وقت التكرار : [ '..TIME_CHECK..' ]\n\n'
..'↫ اعدادات اخرى :\n\n'
..'✤ قفل الرد : '..getsettings('reply')..'\n'
.. '✤ قفل الفشار : '..getsettings('fosh')..'\n'
.. '✤ قفل بوتات الجهات : '..getsettings('tabchi')..'\n'
..'✤ قفل الدخول : '..getsettings('join')..'\n'
..'✤ قفل العربيه : '..getsettings('arabic')..'\n'
..'✤ قفل التثبيت : '..getsettings('pin')..'\n'
.. '✤ قفل السمايلات : '..getsettings('emoji')..'\n'
.. '✤ قفل الشارحه : '..getsettings('cmd')..'\n'
..'✤ الترحيب : '..getsettings('welcome')..'\n'
..'✤ قفل الانكليزيه : '..getsettings('english')..'\n'
.. '✤ قفل بصمه السلفي : '..getsettings('selfvideo')..'\n'
..'✤ قفل الاشعارات : '..getsettings('tgservice')..'\n'
..'✤ قفل الانلاين : '..getsettings('inline')..'\n\n'
..'↫ اعدادات الميديا :\n\n'
..'✦ قفل الصوت : '..getsettings('voice')..'\n'
..'✦ قفل المتحركه : '..getsettings('gif')..'\n'
..'✦ قفل الملفات : '..getsettings('file')..'\n'
..'✦ قفل الدردشه : '..getsettings('text')..'\n'
..'✦ قفل الفيديو : '..getsettings('video')..'\n'
..'✦ قفل الالعاب : '..getsettings('game')..'\n'
..'✦ قفل الصور : '..getsettings('photo')..'\n'
..'✦ قفل الموسيقى : '..getsettings('music')..'\n'
..'✦ قفل الملصقات : '..getsettings('sticker')..'\n'
..'✦ قفل الجهات : '..getsettings('contact')..'\n\n'
.."↫ اعدادات الحمايه :\n\n"
.."⇦ عدد التحذير : ( `"..wmax.."/10` )\n"
..'⇦ المجموعه : '..getsettings('muteall')..'\n'
.."⇦ ايديك : ( `"..msg.sender_user_id_.."` )\n"
.."⇦ ايدي الكروب : ( `"..msg.chat_id_.."` )\n\n"
bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
-------------------------------------------------Flood------------------------------------------------
if text and text:match('^وضع تكرار (%d+)$') then
database:hset("flooding:settings:"..msg.chat_id_ ,"floodmax" ,text:match('setfloodmax (.*)'))
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*The Maximum Message Sending Speed Is Set To :* [ `'..text:match('setfloodmax (.*)')..'` ]', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم وضع التكرار ( `'..text:match('setfloodmax (.*)')..'` ) .', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^وضع وقت التكرار (%d+)$') then
database:hset("flooding:settings:"..msg.chat_id_ ,"floodtime" ,text:match('setfloodtime (.*)'))
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*Maximum Reception Recognition Time Set to :* [ `'..text:match('setfloodtime (.*)')..'` ]', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم وضع رقت التكرار ( `'..text:match('setfloodtime (.*)')..'` )  .', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'link' or text == 'الرابط' then
local link = database:get(SUDO..'grouplink'..msg.chat_id_)
if link then
if database:get('lang:gp:'..msg.chat_id_) then
 bot.sendMessage(msg.chat_id_, msg.id_, 1, '*📮┇ Group Link :* \n'..link, 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '📮┇ رابط المجموعه :  \n'..link, 1, 'md')
end
else
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*The Link To The Group Has Not Been Set*\n*Register New Link With Command*\n/setlink link\n*It Is Possible.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ لا يوجد رابط يرجى وضع الرابط !', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if text == 'rules' or text == 'القوانين' then
local rules = database:get(SUDO..'grouprules'..msg.chat_id_)
if rules then
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Group Rules :* \n'..rules, 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ قوانين المجموعه : \n'..rules, 1, 'md')
end
else
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Rules Are Not Set For The Group.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ لا يوجد قوانين للمجموعه !', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if text == 'mutechat' or text == 'قفل المحادثه' then
database:set(SUDO..'muteall'..msg.chat_id_,true)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Filter All Conversations Enabled!*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇ قفل المحادثه نشط .', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'unmutechat' or text == 'فتح المحادثه' then
database:del(SUDO..'muteall'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*All Conversations Filtered Disabled!*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇  قفل المحادثه معطل .', 1, 'md')
end
end
----------------------------------------------------------------------------
if (text == 'kick' or text == 'طرد') and tonumber(msg.reply_to_message_id_) > 0 then
function kick_by_reply(extra, result, success)
kick(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),kick_by_reply)
end
----------------------------------------------------------------------------
if text and text:match('^kick (%d+)') then
kick(msg,msg.chat_id_,text:match('kick (%d+)'))
end
if text and text:match('^طرد (%d+)') then
kick(msg,msg.chat_id_,text:match('طرد (%d+)'))
end
-------------------------------------------------Ban-------------------------------------------------
if (text == 'ban' or text == 'حظر') and tonumber(msg.reply_to_message_id_) > 0 then
function banreply(extra, result, success)
ban(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),banreply)
end
----------------------------------------------------------------------------
if text and text:match('^ban (%d+)') then
ban(msg,msg.chat_id_,text:match('ban (%d+)'))
end
if text and text:match('^حظر (%d+)') then
ban(msg,msg.chat_id_,text:match('حظر (%d+)'))
end
----------------------------------------------------------------------------
if (text == 'unban' or text == 'الغاء حظر') and tonumber(msg.reply_to_message_id_) > 0 then
function unbanreply(extra, result, success)
unban(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply)
end
----------------------------------------------------------------------------
if text and text:match('^unban (%d+)') then
unban(msg,msg.chat_id_,text:match('unban (%d+)'))
end
if text and text:match('^الغاء حظر (%d+)') then
unban(msg,msg.chat_id_,text:match('الغاء حظر (%d+)'))
end
----------------------------------------------------------------------------
if text == 'banlist' or text == 'المحظورين' then
local list = database:smembers(SUDO..'banned'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '🚸┇ banlist :\n\n'
else
t = '🚸┇ قائمه المحظورين :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '*The List Of Member Blocked Is Empty.*'
else
t = '🚸┇ لا يوجد محظورين'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'مسح المحظورين' then
database:del(SUDO..'banned'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*The List Of Blocked Users From The Group Was Successfully Deleted.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم حذف قائمه المخظورين.', 1, 'md')
end
end
----------------------------------------------------------------------------
if (text == 'silent' or text == 'كتم') and tonumber(msg.reply_to_message_id_) > 0 then
function mutereply(extra, result, success)
mute(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),mutereply)
end
----------------------------------------------------------------------------
if text and text:match('^silent (%d+)') then
mute(msg,msg.chat_id_,text:match('silent (%d+)'))
end
if text and text:match('^كتم (%d+)') then
mute(msg,msg.chat_id_,text:match('كتم (%d+)'))
end
----------------------------------------------------------------------------
if (text == 'unsilent' or text == 'الغاء كتم') and tonumber(msg.reply_to_message_id_) > 0 then
function unmutereply(extra, result, success)
unmute(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unmutereply)
end
----------------------------------------------------------------------------
if text and text:match('^unsilent (%d+)') then
unmute(msg,msg.chat_id_,text:match('unsilent (%d+)'))
end
if text and text:match('^الغاء كتم (%d+)') then
unmute(msg,msg.chat_id_,text:match('الغاء كتم (%d+)'))
end
----------------------------------------------------------------------------
if text == 'silentlist' or text == 'المكتومين' then
local list = database:smembers(SUDO..'mutes'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '*🚸┇ User List Silent Mode :*\n\n'
else
t = '🚸┇ قائمه المكتومين :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '*🚸┇ The List Of Silent Member Is Empty !*'
else
t = '🚸┇ لا يوجد مكتومين '
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'clean silentlist' or text == 'مسح المكتومين' then
database:del(SUDO..'mutes'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*🚸┇ List of Member In The List The Silent List Was Successfully Deleted.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم مسح قائمه الكتم', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^del (%d+)$') or text:match('^تنظيف (%d+)$') then
local limit = tonumber(text:match('^del (%d+)$') or text:match('^تنظيف (%d+)$'))
if limit > 1000 then
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*The Number Of Messages Entered Is Greater Than The Limit (*`1000` *messages)*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🚸┇  يمكن يتنضيف اكثر من ( 1000 ) ', 1, 'md')
end
else
function cb(a,b,c)
local msgs = b.messages_
for i=1 , #msgs do
delete_msg(msg.chat_id_,{[0] = b.messages_[i].id_})
end
end
bot.getChatHistory(msg.chat_id_, 0, 0, limit + 1,cb)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'[ `'..limit..'` ] *Recent Group Messages Deleted !*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, ' 🚸┇ عدد الرسائل ( `'..limit..'` ) تم حذفها', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if tonumber(msg.reply_to_message_id_) > 0 then
if text == "del" then
delete_msg(msg.chat_id_,{[0] = tonumber(msg.reply_to_message_id_),msg.id_})
end
end
-------------------------------------------------Filter Word-------------------------------------------------
if text and text:match('^filter (.*)') or text:match('^منع (.*)') then
local w = text:match('^filter (.*)') or text:match('^منع (.*)')
database:sadd(SUDO..'filters:'..msg.chat_id_,w)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'[` '..w..'` ] *Was Added To The List Of Filtered Words!*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ الكلمه ( '..w..' ) تم اضافتها الى قائمه المنع', 1, 'html')
end
end
----------------------------------------------------------------------------
if text and text:match('^unfilter (.*)') or text:match('^الغاء منع (.*)') then
local w = text:match('^unfilter (.*)') or text:match('^الغاء منع (.*)')
database:srem(SUDO..'filters:'..msg.chat_id_,w)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'[ `'..w..'` ] Was Deleted From The Filtered List', 1, 'html')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ الكلمه ( '..w..' ) تم حذفها من قائمه المنع', 1, 'html')
end
end
----------------------------------------------------------------------------
if text == 'clean filterlist' or text == 'مسح قائمه المنع' then
database:del(SUDO..'filters:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*All Filtered Words Have Been Successfully Deleted.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'🚸┇ تم حذف جميع الكلمات الممنوعه', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'filterlist' or text == 'قائمه المنع' then
local list = database:smembers(SUDO..'filters:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '*🚸┇ List Of Words Filtered In Group :*\n\n'
else
t = '🚸┇ قائمه المنع :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - "..v.."\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '*🚸┇ Filtered Word List Is Empty*'
else
t = '🚸┇ لا يوجد كلمات ممنوعه'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if (text == 'pin' or text == 'تثبيت') and msg.reply_to_message_id_ ~= 0 then
local id = msg.id_
local msgs = {[0] = id}
pin(msg.chat_id_,msg.reply_to_message_id_,0)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "*🚸┇ Your message was pinned*", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "🚸┇ تم تثبيت الرساله", 1, 'md')
end
end
----------------------------------------------------------------------------
if (text == 'unpin' or text == 'الغاء تثبيت') and msg.reply_to_message_id_ ~= 0 then
local id = msg.id_
local msgs = {[0] = id}
unpin(msg.chat_id_,msg.reply_to_message_id_,0)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "*🚸┇message unpinned*", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "🚸┇ تم الغاء تثبيت الرساله", 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('الحساب (%d+)') then
local id = text:match('الحساب (%d+)')
local text = 'click'
tdcli_function ({ID="SendMessage", chat_id_=msg.chat_id_, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=11, user_id_=id}}}}, dl_cb, nil)
end
----------------------------------------------------------------------------
if text == "ايدي" then
function id_by_reply(extra, result, success)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '🕴┇ الايدي : ( `'..result.sender_user_id_..'` )', 1, 'md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),id_by_reply)
end
end
----------------------------------------------------------------------------
end -- end is_mod msg
----------------------------------------------------------------------------
-- memeber
----------------------------------------------------------------------------
if text and text:match('^تفعيل') and not database:get(SUDO.."active:"..msg.chat_id_) then
database:set(SUDO.."active:"..msg.chat_id_, true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'تم تفعيل المجموعه لرفع مدير المجموعه ارسل /setme \n\n• قناة المطور : '..botchannel..' \n كروب الدعم : \n '..supportgp..'', 1, 'html')
tdcli.forwardMessages(realm_id, msg.chat_id_,{[0] = msg.id_}, 0)
elseif text and text:match('^[Ss]etme') and not database:get(SUDO.."omg:"..msg.chat_id_) then
database:sadd(SUDO.."owners:"..msg.chat_id_, msg.sender_user_id_)
database:set(SUDO.."omg:"..msg.chat_id_, true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'تم وضعك مدير للمجموعه يرجى ارسال /help \n\n➢ قناة المطور : '..botchannel..' \n كروب الدعم : \n '..supportgp..'', 1, 'html')
tdcli.forwardMessages(realm_id, msg.chat_id_,{[0] = msg.id_}, 0)
end
----------------------------------------------------------------------------
if text and msg_type == 'text' and not is_muted(msg.chat_id_,msg.sender_user_id_) then
----------------------------------------------------------------------------
if text == "بوت" then
if database:get('ranks:'..msg.sender_user_id_) then
local rank =  database:get('ranks:'..msg.sender_user_id_)
local  k = {"كول عمري","ها حبيبي","شكو كول","هااا شتريد مني خليني بشغلي","وجع شكو","احجي خلصني" ,"اهو اجتي العطلات"}
bot.sendMessage(msg.chat_id_, msg.id_, 1,''..k[math.random(#k)]..' '..rank..'',1,'md')
else
local p = {"  عجب شون وياكم كول","هاا ","اححح شيخلصنه","كول😐","اوف كول خلصني","اهوووو ها شتريد ","احجي"," ها بلههه","😕" ,"شكو","هاا😐"}
bot.sendMessage(msg.chat_id_, msg.id_, 1,''..p[math.random(#p)]..'', 1, 'html')
end
end
----------------------------------------------------------------------------

if text and text:match('^[Mm]e') or text:match("^رتبتي$") then
local rank =  database:get('ranks:'..msg.sender_user_id_) or '------'
local msgs = database:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
if is_ultrasudo(msg) then
t = 'مطور اساسي'
elseif is_sudo(msg) then
t = 'مطور'
elseif is_founder(msg) then
t = 'منشئ المحموعه'
elseif is_owner(msg) then
t = 'مدير الكروب'
elseif is_mod(msg) then
t = 'ادمن'
elseif is_vip(msg) then
t = 'عضو مميز'
else
t = 'عضو فقط'
end
local nwarn = database:hget("warn:"..msg.chat_id_,msg.sender_user_id_) or 0
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» ايديك : [ `'..msg.sender_user_id_..'` ]\n» موقعك : [ '..t..' ]\n» التحذيرات : [ `'..nwarn ..'` ]\n↫ رسائلك : [ `'..msgs..'` ] \n\n', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» ايديك : [ `'..msg.sender_user_id_..'` ]\n» موقعك : [ '..t..' ]\n» التحذيرات : [ `'..nwarn ..'` ]\n↫ رسائلك : [ `'..msgs..'` ]\n\n', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^bot rules$') or text:match("^قوانين البوت$") then

text = [[
قواعد استخدام البوت! 📚


يرجى قراءة القواعد أدناه ثم استخدام البوت ؛ وإلا ، دعونا نتجاهل عواقبه!

1- لا تقم بتثبيت الروبوت في مجموعات إباحية ، ضد الله ، والأحزاب السياسية !
2- لا تكرر الأوامر!
3- لا تستخدم الروبوت في مجموعات حيث يوجد البوتات الأخرى!
4. إذا كان البوت لا يستجيب ، تأكد من الاشتراك في قناة الدعم!

في حالة وجود أي مشكلة ، أرسل أمر `معلومات البوت`!
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'md')
end
-----------------------------------------------------------------------------
if text:match("^[Nn]ote (.*)$") or text:match("^مذكره (.*)$") and is_sudo(msg) then
          local txt = {
            string.match(text, "^([Nn]ote) (.*)$")
          }
          database:set("Sudo:note" .. msg.sender_user_id_, txt[2])
          if database:get("lang:gp:" .. msg.chat_id_) then
            bot.sendMessage(msg.chat_id_, msg.id_, 1, "• Your note has been saved !", 1, "md")
          else
            bot.sendMessage(msg.chat_id_, msg.id_, 1, "تم حفظ المذكره الخاصه بك !", 1, "md")
          end
        end
        if text:match("^[Gg]etnote$") or text:match("^جلب المذكره$") and is_sudo(msg) then
          local note = database:get("Sudo:note" .. msg.sender_user_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1, note, 1, nil)
        end
------------------------------------------------------------------------------		
		local idf = tostring(msg.chat_id_)
    if idf:match("-100(%d+)") then
      local chatname = chat and chat and chat.title_
      local svgroup = "group:Name" .. msg.chat_id_
      if chat and chatname then
        database:set(svgroup, chatname)
      end
    end
	local text = msg.content_.text_:gsub('مسح المحذوفين','clean delete')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Ll][Ee][Tt][Ee]$") and is_mod(msg) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Ll][Ee][Tt][Ee])$")}
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
  else
local group_id = chat_id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
  end
  return chat
end
  local function check_delete(arg, data)
for k, v in pairs(data.members_) do
local function clean_cb(arg, data)
if not data.first_name_ then
bot.changeChatMemberStatus(msg.chat_id_, data.id_, "Kicked")
end
end
bot.getUser(v.user_id_, clean_cb)
end
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> delete accounts has been_ *Cleaned*'
else
text = ' تم طرد جميع الحسابات المحذوفه '
end
	bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
 end
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID,offset_ = 0,limit_ = 5000}, check_delete, nil)
  end

----------------------------------------------------------------------------
if text and text:match("^[Pp]ing$") or text:match("^بوت$") then
text = 'BOT INLINE'
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, ''..text..'' , 0, string.len(text))
end
----------------------------------------------------------------------------
if text == "id" or text == "Id" or text == "ايدي" or text == "ایدی" or text == "ID" then
if check_user(msg) then
if msg.reply_to_message_id_ == 0 then
local rank =  database:get('ranks:'..msg.sender_user_id_) or 'لا يوجد !'
local msgs = database:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)

if is_ultrasudo(msg) then
t = 'مطور اساسي'
elseif is_sudo(msg) then
t = 'مطور'
elseif is_founder(msg) then
t = 'منشئ المحموعه'
elseif is_owner(msg) then
t = 'مدير الكروب'
elseif is_mod(msg) then
t = 'ادمن'
elseif is_vip(msg) then
t = 'عضو مميز'
else
t = 'عضو فقط'

end

local gmsgs = database:get(SUDO..'groupmsgkk:'..msg.chat_id_..':')
local msgs = database:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
local function getpro(extra, result, success)
if result.photos_[0] then
if database:get('lang:gp:'..msg.chat_id_) then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,'↫ ايديك : [ '..msg.sender_user_id_..' ]\n↫ موقعك : [ '..t..' ]\n↫عدد رسائلك : [ '..msgs..' ]\n↫عدد صورك : [ '..result.total_count_..' ]\n️➢ قناة المطور : '..botchannel..'', 1, 'md')
else
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,'↫ ايديك : [ '..msg.sender_user_id_..' ]\n↫ موقعك : [ '..t..' ]\n↫ عدد رسائلك : [ '..msgs..' ]\n↫عدد صورك : [ '..result.total_count_..' ]\n️➢ قناة المطور : '..botchannel..'', 1, 'md')
end
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ انت لا تملك صوره ! \n\n» ايديك : ( '..msg.sender_user_id_..' ) \n\n↫ ايدي الكروب : ( '..msg.chat_id_..' )\n\n↫ رسايلك : ( '..msgs..' ) \n \n↫ رسائل الكروب : ( '..gmsgs..' ) \n\n↫ موقعك : ( '..rank..' ) \n\n➢ قناة المطور : '..botchannel..'', 1, 'md')
end
end
tdcli_function ({
ID = "GetUserProfilePhotos",
user_id_ = msg.sender_user_id_,
offset_ = 0,
limit_ = 1
}, getpro, nil)
end
end
end
----------------------------------------------------------------------------
if text:match("^[Dd][Ee][Vv]$") or text:match("^المطور$") or text:match("^مطور$") or text:match("^sudo$") or text:match("^مطورين$") then
sendContact(msg.chat_id_, msg.id_, 0, 1, nil, (9647829374642), ("Ms >> beko"), "", bot_id)
end
----------------------------------------------------------------------------
if text:match("^رابط الحذف$") or text:match("^delete account$") or text:match("^رابط حذف$") then
local text =  [[
↫ رابط حذف التلي ⬇️:

(https://telegram.org/deactivate)

]]

bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'md')
end
if text:match("^معلومات البوت$") or text:match("^support$") then
local text =  [[

✪ بوت التواصل :

➥ ]] ..pvresan.. [[

✪ معرف المطور  :

➥ ]] ..sudoid..[[

✪ كروب الدعم :

➥ ]] ..supportgp.. [[


✪ اسم البوت :

➥ ]] ..botname.. [[

✪ قناة المطور :

➥ ]] ..botchannel.. [[

]]

bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
---------------------------------------------------------------
----------------------------------------------------------------------------
local text = msg.content_.text_:gsub('مسح المتروكين','clean deactive')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Aa][Cc][Tt][Ii][Vv][Ee]$") and is_mod(msg) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Aa][Cc][Tt][Ii][Vv][Ee])$")}
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
  else
local group_id = chat_id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
  end
  return chat
end
  local function check_deactive(arg, data)
for k, v in pairs(data.members_) do
local function clean_cb(arg, data)
if data.type_.ID == "UserTypeGeneral" then
if data.status_.ID == "UserStatusEmpty" then
bot.changeChatMemberStatus(msg.chat_id_, data.id_, "Kicked")
end
end
end
bot.getUser(v.user_id_, clean_cb)
end
if database:get('bot:lang:'..msg.chat_id_) then
text = 'deactive users has been cleaned !'
else
text = 'تم طرد المتروكين !'
end
	bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
 end
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID,offset_ = 0,limit_ = 5000}, check_deactive, nil)
  end
----------------------------------------------------------------------------
if text:match("^[Rr]uadmin$") and is_sudo(msg) or text:match("^ادمن$") and is_mod(msg) then
if msg.can_be_deleted_ == true then
if database:get("lang:gp:" .. msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, "I'm *Admin* !", 1, "md")
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "انا ادمن !", 1, "md")
end
elseif database:get("lang:gp:" .. msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, "I'm *Not Admin* !", 1, "md")
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "انا لست ادمن !", 1, "md")
end
end
----------------------------------------------------------------------------
end -- end check mute
 -- edit and updated by : @fiq_king
end -- end text
 -- edit and updated by : @fiq_king
end  -- end is_supergroup
 -- edit and updated by : @fiq_king
end -- end function
----------------------------------------------------------------------------
function tdcli_update_callback(data)
if (data.ID == "UpdateNewMessage") then
run(data.message_,data)
elseif (data.ID == "UpdateMessageEdited") then
data = data
local function edited_cb(extra,result,success)
run(result,data)
end
tdcli_function ({
ID = "GetMessage",
chat_id_ = data.chat_id_,
message_id_ = data.message_id_
}, edited_cb, nil)
elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
tdcli_function ({
ID="GetChats",
offset_order_="9223372036854775807",
offset_chat_id_=0,
limit_=20
}, dl_cb, nil)
end
end
