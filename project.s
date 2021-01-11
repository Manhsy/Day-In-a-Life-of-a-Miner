.data

gameover:
	.ascii "\n"
	.ascii "     _________    _____   ____     _______  __ ___________ \n"                                                         
	.ascii "    / ___\\__  \\  /     \\_/ __ \\   /  _ \\  \\/ // __\\_  __  \\ \n"
	.ascii "   / /_/  > __ \\|  Y Y  \\  ___/  (  <_> )   /\\  ___/|  | \\/ \n"
	.ascii "   \\___  (____  /__|_|  /\\___  >  \\____/ \\_/  \\___  >__|     \n"
	.ascii "  /_____/     \\/      \\/     \\/                   \\/        \n\0"


sluiceRepair:
	.ascii "You repaired the sluice to 100%.\n\n\0"
title:
	.ascii "━━━━━━━☆☆☆☆☆☆━━━━━━━\nCALIFORNIA GOLD RUSH\n━━━━━━━☆☆☆☆☆☆━━━━━━━\n\n\0"
rules:
	.ascii "Rules:\n1. 20 weeks (5 months)\n2. Your endurance drops 10-25% each week. If it reaches 0%, the game ends.\n3. Panning for gold yields 0-100 dollars.\n4. A sluice yields 0-1000 dollars (durability drops 20-50% each week)\n5. Food costs 30-50 dollars\n\n\0"
rules2:
	.ascii " ☞ ☞ ☞ EACH WEEK YOU WILL HAVE THREE ACTIVITIES TO CHOOSE FROM.\nHOWEVER, BECAREFUL WHEN YOU CHOOSE TO GO OUT, YOU WILL HAVE 1 IN 5 CHANCES TO BE KILLED BY THE GOLD THIEVES\n\0"
lineBreak:
	.ascii "\n\0"
weekCounter:
	.quad 1
week:
	.ascii "WEEK \0"

dollars:
	.quad 100
dStatement:
	.ascii "You have $\0"
endurance:
	.quad 100
eStatement:
	.ascii "You endurance is at \0"
sluice: 
	.quad 100
sStatement:
	.ascii "Sluice is at \0"
percent:
	.ascii "%\0"
choices:
	.ascii "It's Sunday! Do you want to 1. Do nothing 2. Repair sluice (-$100) 3. go to town.\n\0"
gameOver:
	.ascii "(⁀ᗢ⁀) GAME OVER (⁀ᗢ⁀)\n\n\0"
finalMoney:
	.ascii "»»»You ended the game with $\0" #call dollar
finalEndurance:
	.ascii "»»»You endurance was \0" #call endurance
goldYield:
	.ascii "※※※Panning for gold yielded $\0"
sluiceYield:
	.ascii "※※※The sluice yielded $\0"
foodCost:
	.ascii "※※※You ate $\0"
foodCost2:
	.ascii " in food\0"
goingOut$:
	.ascii "Going out costed you $\0"
goingOutE:
	.ascii "You regained \0"
e:
	.ascii " endurance.\0"
brokenSluice:
	.ascii "※※※your sluice is broken, you have earned $0 from the sluice,\nplease repair it for future use.٩(╬ʘ益ʘ╬)۶\n\0"
gotKilled:
	.ascii "While going out, you got killed because you were bragging about how much gold you mined ☹\n\0"
congrats:
	.ascii "Congrats, while going out you manage to dodge all the thieves and returned home safely, carry on with your week ☺\n\0"
.text
.global _start
_start:

	mov $title, %rdx
	call PrintCString

	mov $rules, %rdx
	call PrintCString
	mov $1, %rdx
	call SetForeColor
	mov $rules2, %rdx
	call PrintCString
	mov $7, %rdx
	call SetForeColor

weekLoop:
	mov $7, %rdx
	call SetForeColor
	cmp $21, weekCounter
        je conclusion
        cmp $0, endurance
        jl conclusion

	mov $week, %rdx
	call PrintCString
	mov weekCounter, %rdx
	call PrintInt
	call breakLine

	mov $dStatement, %rdx
	call PrintCString
	mov dollars, %rdx
	call PrintInt
	call breakLine

	mov $eStatement, %rdx
	call PrintCString
	mov endurance, %rdx
	call PrintInt
	mov $percent, %rdx
	call PrintCString
	call breakLine

	mov $sStatement, %rdx
	call PrintCString 
	mov sluice, %rdx
	call PrintInt
	mov $percent, %rdx
	call PrintCString
	call breakLine
	
	call userInput

userInput:
	add $1, weekCounter
	mov $choices, %rdx
	call PrintCString
	call ScanInt

	cmp $1, %rdx
	je option1


	cmp $2, %rdx
	je option2

	cmp $3, %rdx 
	je option3
	
option1:
	call goldPanning
	#call sluiceEarning
	call checkSluice
	call foodSubtraction
	call enduranceDecrease
	call sluiceDecrease

	jmp weekLoop
option2:	
	call breakLine	
	sub $100, dollars
	call repairSluice
	mov $2, %rdx
	call SetForeColor
	mov $sluiceRepair, %rdx
	call PrintCString
	mov $7, %rdx
	call sluiceDecrease
	call SetForeColor
	call goldPanning
	call sluiceEarning
	call foodSubtraction
	call enduranceDecrease

	jmp weekLoop
option3:
	call GoOutEvents
	call enduranceRepair
	call goldPanning
	#call sluiceEarning
	call checkSluice
	call foodSubtraction
	call sluiceDecrease
	
	jmp weekLoop
GoOutEvents:
	mov $5, %rdx
	call Random
	cmp $1, %rdx
	je dead
	mov $6, %rdx
	call SetForeColor
	mov $congrats, %rdx
	call PrintCString
	mov $7, %rdx
	call SetForeColor
	ret
dead:
	mov $1, %rdx
	call SetForeColor
	mov $gotKilled, %rdx
	call PrintCString
	jmp conclusion
repairSluice:
	movq $100, sluice
	#add $1, sluice	
	#cmp $100, sluice
	#jl repairSluice
	ret
enduranceRepair:
	call breakLine
	mov $151, %rdx
	call Random
	add $50, %rdx
	mov %rdx, %r15
	sub %r15, dollars
	mov $1, %rdx
	call SetForeColor
	mov $goingOut$, %rdx
	call PrintCString
	mov %r15, %rdx
	call PrintInt
	mov $7, %rdx
	call SetForeColor
	call breakLine 

	mov $46, %rdx
	call Random
	add $5, %rdx
	add %rdx, endurance
	mov %rdx, %rax
	mov $2, %rdx
	call SetForeColor
	mov $goingOutE, %rdx
	call PrintCString
	mov %rax, %rdx
	call PrintInt
	mov $percent, %rdx
	call PrintCString
	mov $e, %rdx
	call PrintCString
	mov $7, %rdx
	call SetForeColor
	call breakLine
	call breakLine

	ret
goldPanning:

	#RANDOM NUMBER 0-100 while panning for gold
	mov $101, %rdx
	call Random
	mov %rdx, %r12
	call breakLine
	mov $goldYield, %rdx
	call PrintCString
	mov %r12, %rdx
	call PrintInt
	call breakLine
	add %r12, dollars
	ret
checkSluice:
	cmp $0, sluice
	jg sluiceEarning
	jle tellUserBrokenSluice
	ret
tellUserBrokenSluice:
	mov $1, %rdx
	call SetForeColor
	mov $brokenSluice, %rdx
	call PrintCString
	mov $7, %rdx
	call SetForeColor
	ret
sluiceEarning:
	#RANDOM NUMBER 0-1000 sluice earning
        mov $1001, %rdx
        call Random
        mov %rdx, %r14
	mov $sluiceYield, %rdx
	call PrintCString
	mov %r14, %rdx
	call PrintInt
	call breakLine
        add %r14, dollars
	ret
foodSubtraction:
	#RANDOM NUMBER 30-50 to subtract from total money for eating food 
	mov $21, %rdx
	call Random
	add $30, %rdx
	mov %rdx, %r13
	mov $foodCost, %rdx
	call PrintCString
	mov %r13, %rdx
	call PrintInt
	mov $foodCost2, %rdx
	call PrintCString
	call breakLine
	call breakLine
	sub %r13, dollars
	ret

sluiceDecrease:
	# RANDOM NUMBER 20-50 for sluice to go down
	mov $31, %rdx
	call Random
	add $20, %rdx
	sub %rdx, sluice
	ret

enduranceDecrease:
	#RANDOM NUMBER 10-25
	mov $16,  %rdx
	call Random 
	add $10, %rdx
	sub %rdx, endurance
	ret 

breakLine:
	mov $lineBreak, %rdx
        call PrintCString
        ret

conclusion:
	mov $4, %rdx	
	call SetForeColor
	mov $gameOver, %rdx
	call PrintCString
	mov $finalMoney, %rdx
	call PrintCString
	mov dollars, %rdx
	call PrintInt
	call breakLine
	mov $finalEndurance, %rdx
	call PrintCString
	mov endurance, %rdx
	call PrintInt
	mov $percent, %rdx
	call PrintCString 
	call breakLine
	mov $7, %rdx
	call SetForeColor

	mov $gameover, %rdx
	call PrintCString
	jmp end
	
end:
	call EndProgram
