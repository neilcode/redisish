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

SMALLSET = ['SET neil 5', 'SET elisse 5', 'GET neil', 'NUMEQUALTO 5', 'UNSET neil', 'GET neil']