.data
podajWiersze: 		.asciiz "\nPodaj ilosc wierszy: "
podajKolumny: 		.asciiz "\nPodaj ilosc kolumn: "	
ktoryWierszSumowac1: 		.asciiz "\nPodaj pierwszy wiersz, ktory bedzie sumowany (indeksowanie od zera): "
ktoryWierszSumowac2: 		.asciiz "\nPodaj drugi wiersz, ktory bedzie sumowany (indeksowanie od zera):"
pozaZakres:		.asciiz "Wprowadzono wartosc spoza zakresu. Zrobo to jeszcze raz!\n"	
podajElement: 		.asciiz "Podaj element o indeksach i, j ("
nawiasZamykajacy:		.asciiz ") : "		
drukujPrzecinek: 			.asciiz ", "
newLine: 		.asciiz "\n"
again: 		.asciiz "\nUzytkowniku! Chcesz powtorzyc?  (1-tak/0-nie): "
zlyWybor: 	.asciiz "\nNie ma takiej opcji zrob to jeszcze raz.\n"
	.text
main:
	jal czytajMacierz
	jal wydrukujMacierz
	jal sumujWiersze
	
	#powtorzyc?
	li $v0, 4 
	la $a0, again
	syscall
	
	#pobierz wybor
	wybieranie:
	li $v0, 5 
	syscall	
		
	beq $v0, 1, main
	beq $v0, 0, exit
	
	#uzytkownik zle wybral
	li $v0, 4
	la $a0, zlyWybor
	syscall
	
	j wybieranie
	
	exit:
	li $v0, 10
	syscall
	
czytajMacierz:
	li $v0, 4 #wypisz zapytanie o wiersze
	la $a0, podajWiersze
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0	# zapisujemy ilosc wierszy w $s1
	
	li $v0, 4 #wypisz zapytanie o kolumny
	la $a0, podajKolumny
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0	# zapisujemy ilosc kolumn w $s2
	
	# alokujemy pamiec
	mul $t0, $s1, $s2 # $t0 = LW * LK
	mul $a0, $t0, 4   # $a0 = 4 * LW * LK
	
	# alokuje pamiec
	li $v0, 9 
	syscall
	
	# adres macierzy do $s3
	move $s3, $v0	

	li $t2, 0	
	petlaW:	# $t2 - index wiersza, $t3 - index kolumny
		beq $t2, $s1, k
		
		li $t3, 0
		petlaKW:
			beq $t3, $s2, zakonczPetleW
			
			#---komunikaty
			li $v0, 4 
			la $a0, podajElement
			syscall
			
			li $v0, 1
			move $a0, $t2
			syscall
			
			li $v0, 4 
			la $a0, drukujPrzecinek
			syscall
			
			li $v0, 1
			move $a0, $t3
			syscall
			
			li $v0, 4 
			la $a0, nawiasZamykajacy
			syscall
			# wczytaj liczbe
			li $v0, 5 
			syscall
			
			mul $t0, $t2, $s2			# $t0 = index wiersza * ilosc kolumn
			add $t0, $t0, $t3			# $t0 = index wiersza * ilosc kolumn + index kolumny
			mul $t0, $t0, 4 			# $t0 = (index wiersza * ilosc kolumn + index kolumny) * 4
			add $t0, $t0, $s3			# $t0 = adres poczatkowy macierzy + (index wiersza * ilosc kolumn + index kolumny) * 4
			
			# zapisuje podany wyraz na miejscu [index wiersza][index kolumny]
			sw $v0, ($t0)	
						
			addi $t3, $t3, 1
			j petlaKW
		zakonczPetleW:
	
		addi $t2, $t2, 1
		j petlaW
		
	k:			
	jr $ra

wydrukujMacierz:
	li $t2, 0	
	w:		# $t2 - index wiersza, $t3 - index kolumny
		beq $t2, $s1, s
		
		li $t3, 0
		loopColOut:
			beq $t3, $s2, r
			
			mul $t0, $t2, $s2			# $t0 = index wiersza * ilosc kolumn
			add $t0, $t0, $t3			# $t0 = index wiersza * ilosc kolumn + index kolumny
			mul $t0, $t0, 4 			# $t0 = (index wiersza * ilosc kolumn + index kolumny) * 4
			add $t0, $t0, $s3			# $t0 = adres poczatkowy macierzy + (index wiersza * ilosc kolumn + index kolumny) * 4
			
			lw $a0, ($t0)	# odczytuje wyraz z miejsca [index wiersza][index kolumny]
				
			li $v0, 1 # wypisuje liczbe 
			syscall
			
			li $v0, 4 
			la $a0, drukujPrzecinek
			syscall
							
			addi $t3, $t3, 1
			j loopColOut
		r:
		
		li $v0, 4 
		la $a0, newLine
		syscall
		
		addi $t2, $t2, 1
		j w
		
	s:
	jr $ra
	
sumujWiersze:
	#zapytaj o wiersze
	li $v0, 4 
	la $a0, ktoryWierszSumowac1
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0  
	
	li $v0, 4
	la $a0, ktoryWierszSumowac2
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0 
	
	bge $t0, $s1, dodajZle #sprawdzam, czy podana wartosc jest odpowiednia
	bge $t1, $s1, dodajZle
	j dodajDobrze #jak sa ok, to skacze do dalszej czesci
	
	dodajZle: #zle wartosci
	
	li $v0, 4 # wypisz blad
	la $a0, pozaZakres
	syscall
	
	j sumujWiersze #zacznij funkcje od poczatku

	dodajDobrze:

	li $t2, 0 # $t2 - licznik kolumny
	f:
		beq $t2, $s2, fend
		
		mul $t3, $t0, $s2			# $t3 = index wiersza 1 * ilosc kolumn
		add $t3, $t3, $t2			# $t3 = index wiersza 1 * ilosc kolumn + aktualny wyraz
		mul $t3, $t3, 4 			# $t0 = (index wiersza 1 * ilosc kolumn + aktualny wyraz) * 4
		add $t3, $t3, $s3			# $t0 = adres poczatkowy macierzy + (index wiersza 1 * ilosc kolumn + aktualny wyraz) * 4
		
		lw $t3, ($t3)	# odczytuje wyraz z miejsca
		
		mul $t4, $t1, $s2			# $t3 = index wiersza 2 * ilosc kolumn
		add $t4, $t4, $t2			# $t3 = index wiersza 2 * ilosc kolumn + aktualny wyraz
		mul $t4, $t4, 4 			# $t0 = (index wiersza 2 * ilosc kolumn + aktualny wyraz) * 4
		add $t4, $t4, $s3			# $t0 = adres poczatkowy macierzy + (index wiersza 2 * ilosc kolumn + aktualny wyraz) * 4
		
		lw $t4, ($t4) # odczytuje wyraz z miejsca
		
		add $t3, $t3, $t4  #dodaje odpowiednie elementy
		
		move $a0, $t3 #wypisz element
		li $v0, 1
		syscall
		
		la $a0, drukujPrzecinek #wypisz przecinek
		li $v0, 4
		syscall
		
		addi $t2, $t2, 1
		j f
		
	fend:

	jr $ra	