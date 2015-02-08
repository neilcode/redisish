FROM_ARGF = [
	'SET neil 5',
	'SET neil 10', 
	'SET elisse 15', 
	'BEGIN', 
	'SET elisse 20',
	'UNSET neil', 
	'ROLLBACK', 
	'GET elisse', 
	'SET elisse 2', 
	'COMMIT', 
	'SET elisse 30', 
	'GET elisse', 
	'ROLLBACK', 
	'END', 
	'GET elisse', 
	'END'
]

SMALLSET = ['SET neil 5', 'SET elisse 5', 'SET neil 10', 'NUMEQUALTO 5', 'NUMEQUALTO 10', 'UNSET neil', 'NUMEQUALTO 10', 'GET neil', 'SET neil 30', 'GET neil', 'GET NEIL', 'GET bob', 'SET elisse 29', 'GET elisse']
#=> 1, 1, 0, NULL, 30, NULL, NULL, 29