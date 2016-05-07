require 'mailgun'

class HomeController < ApplicationController
    def index
    
    end
    
    def write
        @address = params[:address]
        @title = params[:title]
        @content = params[:content]
        
        new_post = Post.new
        new_post.subscriber = @address
        new_post.title = @title
        new_post.content = @content 
        new_post.save
        
        redirect_to "/list"
        
        mg_client = Mailgun::Client.new("key-935ecca722f4784a88894f88431f945c")

        message_params =  {
                            from: 'master@likelion.net',
                            to:   @address,
                            subject: @title ,
                            text:    @content
                        }

        result = mg_client.send_message('sandbox57731f5054654609880ac7b328f88c52.mailgun.org', message_params).to_h!
        logger.info
        message_id = result['id']
        message = result['message']
    end
    
    def list
        @every_post = Post.all.order("id desc")
    end
end
