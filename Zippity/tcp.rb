require 'socket'

def answerer ( zc, question)
    line=`grep '^#{zc}' db.csv|head -1` #match first zipcode in the file. ^ means line begins with 
    arrayified=line.split(",") #put the output into array 
    ans=(arrayified[question]) # return the answer to question ||1=LAND|| 2=WATER || 3=LAT|| 4=LONG
    puts "Answer is #{ans}"
    return ans
end

#regex for catching questions
landre=/land/
waterre=/water/
longitudere=/longitude/
latitudere=/latitude/

#TCP client
hostname = 'c1.easyctf.com'
port = 12483
string=""
s = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
s.connect Socket.pack_sockaddr_in(port, hostname)

  
while char = s.recv(1)  # Read chars from the socket
   string+=char
   
   print char    
   if char=="?" # detect question
       
       zipcode = string.scan(/[0-9]{5}/)
       #zipcode=zipre.match(string)
       zipcode=zipcode[0].to_i.to_s #perhaps an ugly hack, but strips leading 0-es fast
       
       if landre.match(string)
            s.puts(answerer(zipcode,1))
       end    
       
       if waterre.match(string)
            s.puts(answerer(zipcode,2))
       end    
       
       if latitudere.match(string)
            s.puts(answerer(zipcode,3))
       end    
       
       if longitudere.match(string)
            s.puts(answerer(zipcode,4))
       end  
       
       string=""  # empty for next question
   end
end

puts(string)
s.close()
