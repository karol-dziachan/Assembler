.data
	tablica1: .space 1024
	tablica2: .space 1024
	podaj1: .asciiz "Podaj liczbe do ciagu pierwszego: "
	podaj2: .asciiz "Podaj liczbe do ciagu drugiego:  "
	wybor: .asciiz "Czy chcesz dalej podawac liczby do odlozenia (1-tak) : "
	wTablicy1: .asciiz "W ciagu pierwszym: "
	wTablicy2: .asciiz "\nW ciagu drugim: "
	spacja: .asciiz " " 
	podajA: .asciiz "Podaj a: "
	podajB: .asciiz "Podaj b: "
	podajN: .asciiz "Podaj n: "
	zakres1: .asciiz "\nW ciagu pierwszym liczb w zakresie bylo: "
	zakres2: .asciiz "\nW ciagu drugim liczb w zakresie bylo: "
	powtorz: .asciiz "\nCzy chcesz powtorzyc? (1-tak): "
	pozegnanie: .asciiz "\nDowidzenia"
	zlyZakres: .asciiz "Niepoprawnie wprowadzono zakres. Powtorz."
.text
#$t0 bedzie u mnie iteratorem tablicy1, $t1 tablicy drugiej, $t2 iteratorem petli do wyswietlania, $t3 iteratorem drugiej petli
#t4 bedzie licznikiem liczb z zakresu dla ciagu 1. $t5 dla ciagu 2.
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0

	main: 
li $t7, 0
li $t8, 0	
li $t4, 0
li $t5, 0

	#wyswietl podajA
        li $v0,4
	la $a0,podajA
	syscall
	        
	 #pobierz liczbe
	 li $v0,5
	 syscall
	 #zapisz a w $s3
	 move $s3,$v0 
	 
	 #wyswietl podajB
        li $v0,4
	la $a0,podajB
	syscall
	        
	 #pobierz liczbe
	 li $v0,5
	 syscall
	 #zapisz b w $s4
	 move $s4,$v0 
	 
	#sprawdz, czy a<b, poniewaz w zadaniu zakres ma byc [a,b], stad a nie moze byc wieksze
	 bgt $s3, $s4, niepoprawny
	 
	 #wyswietl podajN
        li $v0,4
	la $a0,podajN
	syscall
	        
	 #pobierz liczbe
	 li $v0,5
	 syscall
	 #zapisz n w $s3
	 move $s5,$v0 

		jal czytajCiag1
		jal wyswietl
		
	podsumuj:
	#wyswietl zakres1
        li $v0,4
	la $a0,zakres1
	syscall
	
	li $v0,1
        la $a0,($t4)
        syscall
		
	#wyswietl zakres2
        li $v0,4
	la $a0,zakres2
	syscall
	
	li $v0,1
        la $a0,($t5)
        syscall

		
	#wyswietl pwtorz
        li $v0,4
	la $a0,powtorz
	syscall
	        
	 #pobierz liczbe
	 li $v0,5
	 syscall
	 #zapisz liczbe w $s0
	 move $s0,$v0 
	 
	 beq $s0, 1, main
koniec:
#wyswietl pozegnanie 
        li $v0,4
	la $a0,pozegnanie
	syscall
#koniec programu
	li $v0,10
	syscall 
	
niepoprawny:
	#wyswietl zlyZakres
        li $v0,4
	la $a0,zlyZakres
	syscall
	
	j main
	
	
czytajCiag1: 
	#wyswietl podaj
        li $v0,4
	la $a0,podaj1
	syscall
	        
	 #pobierz liczbe
	 li $v0,5
	 syscall
	 #zapisz liczbe w $s0
	 move $s0,$v0 
	 
	#dodanie do tablicy i inkrementacja iteratora $t0 
	sw $s0, tablica1($t0)
	addi $t0, $t0, 4
	
	addi $t7, $t7, 1
	beq $t7, $s5, czytajCiag2
	 j czytajCiag1
	
	 
czytajCiag2: 
	beq $t8, $s5, k
	#wyswietl podaj
        li $v0,4
	la $a0,podaj2
	syscall
	        
	 #pobierz liczbe
	 li $v0,5
	 syscall
	 #zapisz liczbe w $s0
	 move $s0,$v0 
	 
	#dodanie do tablicy i inkrementacja iteratora $t1
	sw $s0, tablica2($t1)
	addi $t1, $t1, 4
	
	addi $t8, $t8, 1
	blt $t8, $s5, czytajCiag2
k:	
	 jr $ra
	 

	
wyswietl: 

#wyswietl wTablicy
        li $v0,4
	la $a0,wTablicy1
	syscall
	
loop: 
	beq $t0, $t2, wyswietl2

	
	lw $t6, tablica1($t2) 
	
	blt  $t6, $s3, dalej
	bgt $t6, $s4, dalej
addi $t4, $t4, 1
dalej:
		
	li $v0,1
        la $a0,($t6)
        syscall
        
        #wyswietl spacja
        li $v0,4
	la $a0,spacja
	syscall
	
	addi $t2, $t2, 4
	
	jal loop 
	
wyswietl2:	
	
	#wyswietl wTablicy
        li $v0,4
	la $a0,wTablicy2
	syscall
	
loop1: 
	beq $t1, $t3, podsumuj

	
	lw $t6, tablica2($t3) 
	
	blt  $t6, $s3, dalej1
	bgt $t6, $s4, dalej1
addi $t5, $t5, 1
dalej1:
		
	li $v0,1
        la $a0,($t6)
        syscall
        
        #wyswietl spacja
        li $v0,4
	la $a0,spacja
	syscall
	
	addi $t3, $t3, 4
	
	jal loop1 

