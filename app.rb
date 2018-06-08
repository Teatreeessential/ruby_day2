require 'sinatra'
require 'sinatra/reloader'
require 'uri'
require 'httparty'
require 'nokogiri'
require 'rest-client'


get '/' do
    erb:app
end

get '/calculator' do
    num1 = params[:num1].to_i
    num2 = params[:num2].to_i
    @result1 = num1+num2
    @result2 = num1-num2
    @result3 = num1*num2
    @result4 = num1/num2
    erb:calculator
end

get '/numbers' do
   erb:numbers
end

get '/form' do
    erb:form
end

id = "multi"
pw = "campus"

post '/login' do
    
    if id.eql?(params[:id])
        if pw.eql?(params[:pwd])
            redirect '/complete'
        else
            redirect '/error?err_code=1'
        end
    else
        #아이디가 존재하지 않습니다.
        redirect '/error?err_code=2'
    end
end

#계정이 존재하지 않거나 , 비밀번호가 틀린경우
get '/error' do
    if 1==params[:err_code].to_i
        @msg ="비밀번호가 틀립니다."
    elsif 2==params[:err_code].to_i
        @msg = "id가 존재하지 않습니다."
    end
    
    erb:error
end

#계정이 존재해서 로그인이 완벽

get '/complete' do
    erb:complete
end





get '/search' do
    erb:search
end


post '/search' do
    naver = params[:naver]
    google = params[:google]
    
    # puts naver
    
    if naver&&google==''
        url = URI.encode('https://search.naver.com/search.naver?query=' + naver)
        redirect  url
    elsif google&&naver==''
        url = URI.encode( 'https://www.google.co.kr/search?q='+google)
        redirect  url
      
    else
        @msg ="둘 중 하나의 곳에서만 검색을 시도해주세요! "
        erb:error
    end
end

get '/lol' do
    erb:lol
end

post '/lol' do
    option=params[:option].to_s
    id=params[:id]
    url = URI.encode("http://www.op.gg/summoner/userName={#id}")
    
    if option.eql?("op.gg")
        
        redirect url
    
     elsif option.eql?("here")
         
         result=RestClient.get(url)
         stat = Nokogiri::HTML(result)
         @game = stat.css("span.total").first
         @win = stat.css("span.win").first
         @lose = stat.css("span.lose").first
         
        
        
        erb:lol
         
    end
end