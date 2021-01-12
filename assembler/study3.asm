.data
    ileWierszy: .asciiz "Wprowadz ilosc wierszy: "
    ileKolumn:  .asciiz "Wprowadz ilosc kolumn: "
    lewyNawias: .asciiz "Podaj ["
    prawyNawias:.asciiz "] = "
    przecinek:  .asciiz ","
    przecineks: .asciiz ", "
    odstep:     .asciiz " "
    enter:      .asciiz "\n"
    macierz:    .asciiz "\nMACIERZ:\n"
    dane:       .asciiz "Wprowadzonoe nieprawidlowe wymiary macierzy!\n"
    sum:        .asciiz "\nSumowanie po wierszach.\n(Indeksowanie od 0)\nWiersz 1: "
    w2:         .asciiz "Wiersz 2: "
    zlyWiersz:  .asciiz "Wybrano zly wiersz!\n"
    czyZnow:    .asciiz "\nCzy chcesz wprowadzic nowa macierz?(1-tak / 0-nie)"
    zaMaloW:    .asciiz "\nPodana macierz nie ma dwoch wierszy!\n"
    najwiekszy: .asciiz "\nWiersz o najwiekszej wartosci sumy elementow: "
    wwiersz:    .asciiz " wiersz: "
    .eqv DATA_SIZE 4
.text
    main:
        jal tworzMacierz
        jal drukujMacierz
        jal sumujWiersze
        
        li $v0, 4
        la $a0, czyZnow
        syscall
        
        li $v0, 5
        syscall
        
        beq $v0, 1, main
    
        #koniec
        li $v0, 10
        syscall
        
        
    tworzMacierz:
        li $v0, 4
        la $a0, ileWierszy
        syscall
        
        li $v0, 5
        syscall
        
        blez $v0, zleDane
        
        move $a1, $v0           # a1 - ilosc wierszy
        
        li $v0, 4
        la $a0, ileKolumn
        syscall
        
        li $v0, 5
        syscall
        
        blez $v0, zleDane
        
        move $a2, $v0           # a2 - ilosc kolumn
        
        mul $a0, $a1, $a2       # a0 = ilosc wierszy * ilosc kolumn
        mul $a0, $a0, DATA_SIZE # a0 = ilosc wierszy * ilosc kolumn * DATA_SIZE
        
        li $v0, 9
        syscall
        
        move $a3, $v0           # a3 - adres macierzy
        
        li $t0, 0               # t0 - indeks kolumny
        li $t1, 0               # t1 - indeks wiersza
        
        subi $t4, $a1, 1         # t4 - iloscWierszy-1
        subi $t5, $a2, 1         # t5 - iloscKolumn-1
        
        dodawanieLiczb:
                 li $v0, 4
                 la $a0, lewyNawias
                 syscall
        
                 li $v0, 1
                 move $a0, $t1
                 syscall
        
                 li $v0, 4
                 la $a0, przecinek
                 syscall
        
                 li $v0, 1
                 move $a0, $t0
                 syscall
                 
                 li $v0, 4
                 la $a0, prawyNawias
                 syscall
                 
                 li $v0, 5
                 syscall                  # v0 - liczba do zapisania w macierzy
                 
                 #adres+(wiersz*ileKolumn*DATA_SIZE)+(kolumna*DATA_SIZE)
                 #adres+(wiersz*ileKolumn+kolumna)*DATA_SIZE
                 
                 mul $t2, $t1, $a2       # t2 - wiersz*ileKolumn
                 add $t2, $t2, $t0       # t2 -                 +kolumna
                 mul $t2  $t2, DATA_SIZE # t2 -(                        )*DATA_SIZE
                 add $t2, $a3, $t2       # t2 -                                    +adres
                 
                 sw $v0, 0($t2)
                 
                 addi $t2, $t2, DATA_SIZE
                 
                 blt $t0, $t5, zwiekszKolumne
                 blt $t1, $t4, zwiekszWiersz
                 
                 jr $ra
                 
                 zwiekszKolumne:
                        addi $t0, $t0, 1
                        j dodawanieLiczb
                
                 zwiekszWiersz:
                        li $t0, 0
                        addi $t1, $t1, 1
                        j dodawanieLiczb
        
        zleDane:
                 li $v0, 4
                 la $a0, dane
                 syscall
                 j tworzMacierz
                 
    drukujMacierz:
          li $v0, 4
          la $a0, macierz
          syscall    
    
          move $t3, $a3                 # t0 - adres liczby do wyswietlenia
          
          li $t0, 0                     # t0 - indeks kolumny
          li $t1, 0                     # t1 - indeks wiersza
          subi $t4, $a1, 1              # t4 - iloscWierszy-1
          subi $t5, $a2, 1              # t5 - iloscKolumn-1
          
          drukuj:
                lw $a0, 0($t3)
                li $v0, 1
                syscall
                
                li $v0, 4
                la $a0, odstep
                syscall
                
                addi $t3, $t3, DATA_SIZE
                
                blt $t0, $t5, nastepnaKolumna
                blt $t1, $t4, nastepnyWiersz
                
                jr $ra
                
                nastepnaKolumna:
                         addi $t0, $t0, 1
                         j drukuj
                
                nastepnyWiersz:
                         li $t0, 0
                         addi $t1, $t1, 1
                
                         li $v0, 4
                         la $a0, enter
                         syscall
                
                         j drukuj
                
    sumujWiersze:
                subi $t4, $a1, 1              # t4 - iloscWierszy-1
                subi $t5, $a2, 1              # t5 - iloscKolumn-1
                
                li $t6, 0                     # t6 - obecny wiersz
                li $t7, 0                     # t7 - obecna kolumna
                
                li $s7, 0
                li $s6, 0
                ciag:   
                         #adres+(wiersz*ileKolumn*DATA_SIZE)+(kolumna*DATA_SIZE)
                         #adres+(wiersz*ileKolumn+kolumna)*DATA_SIZE
                 
                         mul $t2, $t6, $a2       # t2 - wiersz*ileKolumn
                         add $t2, $t2, $t7       # t2 -                 +kolumna
                         mul $t2  $t2, DATA_SIZE # t2 -(                        )*DATA_SIZE
                         add $t2, $a3, $t2       # t2 -                                    +adres
                         
                         lw $t2, 0($t2)
                         
                         add $s7, $s7, $t2
                         
                         addi $t7, $t7, 1
                         
                         bgt $t7, $t5, nastepnyWierszsz
                         
                         j ciag
                         
                         nastepnyWierszsz:
                                 li $v0, 4
                                 la $a0, enter
                                 syscall
                                 
                                 li $v0, 1
                                 move $a0, $t6
                                 syscall
                                 
                                 li $v0, 4
                                 la $a0, wwiersz
                                 syscall
                                 
                                 li $v0, 1
                                 move $a0, $s7
                                 syscall
                                 
                                 li $t7, 0
                                 bgt $s7, $s6, zamien
                                 
                                 j d
                                 
                                 zamien:
                                       move $s0, $t6
                                       move $s6, $s7
                                       li $s7, 0
                                 d:
                                 addi $t6, $t6, 1
                                 bgt $t6, $t4, koniec
                                 j ciag
                                 
                 koniec:
                        li $v0, 4
                        la $a0, najwiekszy
                        syscall
                 
                        li $v0, 1
                        move $a0, $s0
                        syscall
                        
                        jr $ra                         