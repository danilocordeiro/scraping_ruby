require 'mechanize'
require 'logger'

 
# Cria o agente que vai interagir com as paginas
agent = Mechanize.new
agent.log = Logger.new "mech.log"

# Acessa a pagina de login
page = agent.get('https://editorial.rottentomatoes.com/article/fresh-movies-you-can-watch-for-free-online-right-now/')
 #puts page.body
# Cria um novo arquivo para guardar a lista de filmes
out_file = File.new('lista_de_filmes.txt', 'w')
out_file.puts 'Lista de Filmes:'
 
# Realiza o looping para pegar todas as paginas de produtos
loop do
  # Pega todas as linhas de produtos
  article_movie = page.search('.article_movie_title');
  
  article_movie.each do |p|
    # Extrai as colunas dos produtos, organiza e escreve no arquivo
    puts p
    f = p.search('h2')
    line = "title: #{f.search('a').text}, "
    line += "year: #{f.search('.subtle').text}, "
    line += "score: #{f.search('.tMeterScore').text}"
    out_file.puts line
  end
 
  # Se nao tiverem mais paginas para serem extraidas ele para o looping
  break unless page.link_with(text: 'Next ›')
 
  # Pula de pagina
  page = page.link_with(text: 'Next ›').click
end
 
out_file.close
