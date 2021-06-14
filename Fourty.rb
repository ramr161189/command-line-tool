require 'uri'
require 'net/http'
require 'json'

class Fourty
	$score=Integer(0)
	$value=" "
	$syn_len=Array.new()
	$def_len=Array.new()
	$synonymval=" "
	$compare=""
	$count=Integer(0)
	def self.initial
		uri=URI('https://fourtytwowords.herokuapp.com/words/randomWord?api_key=fb8007781a73a8884e3821dc8f330cf2949b422d2a4be2bac9f1d5def50213d48f04cf2869255230d8e5adc4bee08ed27035a7a65745b5184b37848e93a691c099b93b1b072f24ad7908352ed10947e3')
		res = Net::HTTP.get_response(uri)
		word=res.body if res.is_a?(Net::HTTPSuccess)
	    index1=word.index(':');
		index2=word.index(',')
		value=word[index1+2,index2-8]
		self.initialize(value)
	end

	def self.initialize(word)
		@word=word
		valdef=self.def(@word)
		valsin=self.sin(@word)
		valex=self.ex(@word)
		valant=self.ant(@word)
		puts "Definition of word is:"
		puts valdef
		puts "Synonym of word is "
		puts valsin
		puts "example of word is"
		puts valex
		puts "Antynom of word is "
		puts valant
	end

	def self.def(word)
		@word=word
		$value=@word
		uri=URI("https://fourtytwowords.herokuapp.com/word/#{@word}/definitions?api_key=fb8007781a73a8884e3821dc8f330cf2949b422d2a4be2bac9f1d5def50213d48f04cf2869255230d8e5adc4bee08ed27035a7a65745b5184b37848e93a691c099b93b1b072f24ad7908352ed10947e3")
		res=Net::HTTP.get(uri)
		json=JSON.parse(res)
		definition=String.new()
 		json.each  do |post|
 			puts json
 		definition=post['text']
 		end
			return definition
		
 		#puts titile
		# Create Files
		#arr=new Array(totalItems
		
	end

	def self.sin(word)
		@word=word
		uri=URI("https://fourtytwowords.herokuapp.com/word/#{@word}/relatedWords?api_key=fb8007781a73a8884e3821dc8f330cf2949b422d2a4be2bac9f1d5def50213d48f04cf2869255230d8e5adc4bee08ed27035a7a65745b5184b37848e93a691c099b93b1b072f24ad7908352ed10947e3")
		res=Net::HTTP.get(uri)
		JSON.parse(res) 
		json=JSON.parse(res)
		synonyms=String.new()
		puts json
		json.each  do |post|
		synonyms=post['words']
		end
		return synonyms
	end

	def self.ant(word)
		@word=word
		uri=URI("https://fourtytwowords.herokuapp.com/word/#{@word}/relatedWords?api_key=fb8007781a73a8884e3821dc8f330cf2949b422d2a4be2bac9f1d5def50213d48f04cf2869255230d8e5adc4bee08ed27035a7a65745b5184b37848e93a691c099b93b1b072f24ad7908352ed10947e3")
		res=Net::HTTP.get(uri)
		JSON.parse(res) 
		json=JSON.parse(res)
		if json.length>1
			return json[0]['words']
		else
			return  "Antynom not Found"
		end
	end

	def self.ex(word)
		@word=word
		uri=URI("https://fourtytwowords.herokuapp.com/word/#{@word}/examples?api_key=fb8007781a73a8884e3821dc8f330cf2949b422d2a4be2bac9f1d5def50213d48f04cf2869255230d8e5adc4bee08ed27035a7a65745b5184b37848e93a691c099b93b1b072f24ad7908352ed10947e3")
		res=Net::HTTP.get_response(uri)
		res=Net::HTTP.get(uri)
		json=JSON.parse(res) 
		return json
	end

	def self.play
		uri=URI('https://fourtytwowords.herokuapp.com/words/randomWord?api_key=fb8007781a73a8884e3821dc8f330cf2949b422d2a4be2bac9f1d5def50213d48f04cf2869255230d8e5adc4bee08ed27035a7a65745b5184b37848e93a691c099b93b1b072f24ad7908352ed10947e3')
		res = Net::HTTP.get_response(uri)
		word=res.body if res.is_a?(Net::HTTPSuccess)
	    index1=word.index(':');
		index2=word.index(',')
		value=word[index1+2,index2-8]
		$compare=value
		$synonymval=value
		valdef=self.def(value)
		@definition=valdef.split(".")
		@synonym=self.sin(value)
		@antynom=self.ant(value)
		$count=@definition.length+@synonym.length+@antynom.length
		puts value
		self.validation(value)	
end

def self.validation(value)
		@value=value
		if($count==0)
			puts @value.split(" ").shuffle.join
		else
			num=rand 0..1
			case num
			when 0
				$count=$count-1
				valdef=self.def(@value)
				@definition=valdef.split(".")
				index=rand 0...@definition.length
				@definition.delete_at(index)
				$def_len=@definition
				puts @definition[index]
			when 1
				$count=$count-1
				@synonym=self.sin(@value)
				index=rand 0...@synonym.length
				@synonym.delete_at(index)
				$syn_len=@synonym
				puts @synonym[index]
			when 2
				begin
					raise 'Exception Created!'
						@antynom=self.ant(@value)
						index=rand 0...@antynom.length
						@antynom.delete_at(index)
						$ant_len=@antynom
						puts @antynom[index]
					rescue
						puts 'there is no antynoms'
				end
			else
				puts "no hint"
			end
		end
	self.guess($synonymval)
end

def self.guess(word)
	@word=word
	print "enter the guess:"
	guessing=gets
	if guessing.casecmp(word)==0
		puts "correct"
		$score=score+10
		$count=0
		self.play
	else
		t=Integer(0)
		for i in 0...$syn_len.length
			if guessing.casecmp?(@word)==0
				$score=score+10
				puts "correct"
				t=1
				$count=0
				self.play
			end
		end
		if(t==0)
			puts "Wrong guess"
			puts "1for tryagin\n2for hint\n3for skip"
			option=Integer(gets)
			case option
			when 1
				$score=$score-2
				puts "your score is #{$score}"
				self.guess(@word)
			when 2
				$score=$score-3
				puts "your score is #{$score}"
				self.validation(@word)
			when 3
				$score=$score-4
				puts "your score is #{$score}"
				$count=0
				self.play
			end

		end
	end
end
end

