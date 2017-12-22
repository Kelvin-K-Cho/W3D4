def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie.select('movies.title, movies.id')
  .joins(:actors)
  .where(actors: {name: those_actors} )
  .group(:title, :id)
  .having('COUNT(title) = (?)', those_actors.count)
  # .where(actors: {name: those_actors} )

  # ben = Movie
  # .select(:title, :id)
  # .joins(:actors)
  # .where("actors.name = ?", those_actors[1])
  #
  # benfilms = []
  # ben.each { |movie| benfilms << movie.title}
  # mattfilms = []
  # matt.each { |movie| mattfilms << movie.title}
  #
  # commonfilms = benfilms.select { |f| mattfilms.include?(f)}
  # commonfilms += mattfilms.select { |f| benfilms.include?(f)}
  # commonfilms.uniq
  #
  # Movie
  # .select(:title, :id)
  # .joins(:actors)
  # .where("actors.name = ?", those_actors[0])

end

def golden_age
  # Find the decade with the highest average movie score.
  Movie.select('(movies.yr/10)*10')
  .group('(movies.yr/10)*10')
  .having('AVG(score) > 5')
  .order('AVG(score) DESC')
  .limit(1)
  .pluck('(movies.yr/10)*10').first

end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  subq = Movie.select(:id)
  .joins(:actors)
  .where('actors.name = ?', name)

  Actor.select(:name)
  .joins(:movies)
  .where('actors.name <> ? AND movies.id IN (?)', name, subq)
  .distinct
  .pluck(:name)


end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor
  .select('COUNT(*) as actors')
  .left_outer_joins(:castings)
  .where('castings.actor_id IS NULL')
  .pluck('COUNT(*)').first
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"

  whazzer = "%#{whazzername.chars.join('%')}%"


  Movie
  .select(:id, :title)
  .joins(:actors)
  .where('actors.name ilike ?', whazzer)

end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  Actor.select('actors.id, actors.name, (MAX(yr) - MIN(yr)) as career')
  .joins(:movies)
  .group('actors.id, actors.name')
  .order('(MAX(yr) - MIN(yr)) DESC, actors.name')
  .limit(3)

end
