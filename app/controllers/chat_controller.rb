require 'line/bot'
class ChatController < ApplicationController
	protect_from_forgery with: :null_session

	def webhook
		# 設定回覆文字
		reply_text = keyword_reply(received_text)

		# 傳送訊息到 line
		response = reply_to_line(reply_text)

		# 回應 200
		head :ok
	end 

	# 取得對方說的話
	def received_text
		message = params['events'][0]['message']
		message['text'] unless message.nil?
	end

	# 關鍵字回覆
	def keyword_reply(received_text)
		# 從資料庫查詢關鍵字回覆訊息，&.前面為空則直接回傳nil
	    KeywordMapping.where(keyword: received_text).last&.message
	end 

	# 傳送訊息到 line
	def reply_to_line(reply_text)

		return nil if reply_text.nil? # 沒有觸發到關鍵字就不回覆

		# 取得 reply token
		reply_token = params['events'][0]['replyToken']

		# 設定回覆訊息
		message = {
			type: 'text',
			text: reply_text
		}

		# 傳送訊息
		line.reply_message(reply_token, message)
	end

	# Line Bot API 物件初始化
	def line
		@line ||= Line::Bot::Client.new { |config|
			config.channel_secret = '8bd4ec4245f9bd31616f6a35b41f4826'
			config.channel_token = 'YMJ6ZkSNCg8WRN6gye4dGkRWRPjx6k85egoWGLkYOR+6UII28TeyWm4gVR5VrDxsIdl6F3rRF3MVoOGxp80Y/g3kVyfeMvPZxwuxbLuih+7gb9+5oS4nNrS1AqOYP9l/BMke+l8mGcsq9rIrj6kAKQdB04t89/1O/w1cDnyilFU='
		}

	end

end
