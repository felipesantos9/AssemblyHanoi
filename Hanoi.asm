section .text
    global _start

_start:

    ; Impressão do prompt
    mov eax, 4             
    mov ebx, 1          
    mov ecx, prompt         
    mov edx, len_prompt     
    int 0x80                 
    
    ; Leitura da entrada
    mov eax, 3              
    mov ebx, 0              
    mov ecx, entrada        
    mov edx, 128            
    int 0x80                


    ; Impressão da mensagem inicial
    mov eax, 4              
    mov ebx, 1              
    mov ecx, inicio         
    mov edx, 27             
    int 0x80                


    ; Impressão do número de discos
    mov eax, 4              
    mov ebx, 1              
    mov ecx, entrada        
    mov edx, 1            
    int 0x80                
   

    ; Inicializa a execução do algoritmo Hanoi
    lea esi, [entrada]      
    mov ecx, 1              
    call integer_string     ; converter a entrada em um número
    push dword 2            ; destino
    push dword 3            ; auxiliar
    push dword 1            ; origem
    push eax                ; número de discos
    call hanoi              


    ; Impressão "Concluído!"
    mov eax, 4                  
    mov ebx, 1              
    mov ecx, concluido          
    mov edx, len_concluido      
    int 0x80                    

    ; Termina o programa
    mov eax, 1               
    mov ebx, 0               
    int 0x80                 


hanoi:
    push ebp                 
    mov ebp, esp             

    mov eax, [ebp+8]         
    cmp eax, 0               ; caso base
    je desempilhar           

    ; Chamada recursiva para mover n-1 discos da torre origem para a torre auxiliar
    push dword [ebp+16]      
    push dword [ebp+20]      
    push dword [ebp+12]     
    dec eax                 
    push dword eax           
    call hanoi               
    add esp, 16              

    ; Movimento de disco da torre origem para a torre destino
    push dword [ebp+16]      
    push dword [ebp+12]      
    push dword [ebp+8]       
    call imprime            
    add esp, 12              

    ; Chamada recursiva para mover n-1 discos da torre auxiliar para a torre destino
    push dword [ebp+12]      
    push dword [ebp+16]      
    push dword [ebp+20]      
    mov eax, [ebp+8]         
    dec eax                  
    push dword eax           
    call hanoi               

desempilhar:
    mov esp, ebp   
    pop ebp        ; Desempilha o valor de ebp
    ret            


imprime:
    push ebp         
    mov ebp, esp     

    mov eax, [ebp + 8]    
    add al, 48            ; Converte o número do disco em ASCII
    mov [disco], al       

    mov eax, [ebp + 12]   
    add al, 64            ; Converte o número da torre em ASCII
    mov [torre_saida], al 

    mov eax, [ebp + 16]   
    add al, 64            ; Converte o número da torre em ASCII 
    mov [torre_ida], al   

    mov edx, length       
    mov ecx, msg          
    mov ebx, 1            
    mov eax, 4            
    int 0x80               

    mov esp, ebp   
    pop ebp        
    ret            


integer_string:
  xor ebx, ebx          ; Limpa o registrador ebx
.proximo_digito:       ; Rótulo para o início do loop que percorre os caracteres da string.
  movzx eax, byte [esi]   
  inc esi               
  sub al, '0'            ; Subtrai o valor ASCII '0' para converter para número
  imul ebx, 10           
  add ebx, eax          
  loop .proximo_digito  
  mov eax, ebx           
  ret                  


section .data
    entrada db 128, 0xa
    msg: db " Mova disco ", 0
    disco: db '  da Torre '
    torre_saida: db '  para a Torre ' 
    torre_ida: db ' ', 0xa
    length equ $ - msg

    concluido: db "Concluído!", 0xa
    len_concluido equ $ - concluido
    
    inicio: db " Discos na torre de hanoi: ", 0xa
    len_inicio equ $ - inicio
    
    prompt: db "Número de discos: ", 0xa
    len_prompt equ $ - prompt
