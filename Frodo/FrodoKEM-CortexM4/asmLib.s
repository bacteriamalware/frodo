
.syntax unified
.cpu cortex-m4
.thumb
.align
.thumb_func


.global big2little32
big2little32:
	rev r0, r0
	bx  lr

.global big2little16
big2little16:
	rev16   r0, r0
	bx  lr

@ void mul_row(uint16_t *row_A, uint16_t *S, uint16_t *row_B, uint32_t row_length)
.global mul_row
mul_row:
	//N_bar must be 8
	//r0: pointer row_A
	//r1: pointer S
	//r2: pointer row_B, a_ij
	//r3: row_length/loopcounter
	//r4-r11: row_B
	//r12: s_ij

    push {r2, r4-r12, r14} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop:
		ldr r2, [r0], #4     //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		SUBS r3, #1	//decrement counter
		BNE mul_loop //branch if not zero

	pop {r2} //restore pointer row_B
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]

	pop {r4-r12, r14}//restore registers
	bx  lr

@ void mul_8columns(uint16_t *S, uint16_t *columns_trans_A, uint16_t *col_B, uint32_t row_length)
.global mul_8columns
mul_8columns:
	//N_bar must be 8
	//r0: pointer S
	//r1: pointer columns_trans_A
	//r2: pointer col_B, s_ij
	//r3: row_length/loopcounter
	//r4-r11: row_B
	//r12: a_ij

	//row 1
	push {r1-r12, r14} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop1:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop1 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]
	//increase pointer row_B to show to the next row:
	// 2bytes per element in row -> + row_length + row_length
	add r2, r3
	add r2, r3

	//row 2
	push {r1-r3} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop2:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop2 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]
	//increase pointer row_B to show to the next row:
	// 2bytes per element in row -> + row_length + row_length
	add r2, r3
	add r2, r3

	//row 3
	push {r1-r3} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop3:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop3 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]
	//increase pointer row_B to show to the next row:
	// 2bytes per element in row -> + row_length + row_length
	add r2, r3
	add r2, r3

		//row 4
	push {r1-r3} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop4:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop4 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]
	//increase pointer row_B to show to the next row:
	// 2bytes per element in row -> + row_length + row_length
	add r2, r3
	add r2, r3

		//row 5
	push {r1-r3} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop5:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop5 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]
	//increase pointer row_B to show to the next row:
	// 2bytes per element in row -> + row_length + row_length
	add r2, r3
	add r2, r3

		//row 6
	push {r1-r3} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop6:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop6 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]
	//increase pointer row_B to show to the next row:
	// 2bytes per element in row -> + row_length + row_length
	add r2, r3
	add r2, r3

		//row 7
	push {r1-r3} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop7:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop7 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]
	//increase pointer row_B to show to the next row:
	// 2bytes per element in row -> + row_length + row_length
	add r2, r3
	add r2, r3

		//row 8
	push {r1-r3} //preserve registers
    //load row_B in r4-r11:
    ldrh r4, [r2, #0]
    ldrh r5, [r2, #2]
	ldrh r6, [r2, #4]
	ldrh r7, [r2, #6]
	ldrh r8, [r2, #8]
    ldrh r9, [r2, #10]
	ldrh r10, [r2, #12]
	ldrh r11, [r2, #14]

	lsr r3, r3, #1 //loopcounter/=2, two elements of A in one loop
	mul_loop8:
		ldr r2, [r0], #4    //r2=a_ij+1, a_ij

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		lsr r2, r2, #16      //r2=a_ij+1

		ldmia r1!, {r12,r14} //r12=s_ij+1, s_ij, r14=s_ij+3,s_ij+2
		mla r4, r2, r12, r4  //r4=r2*r12+r4
		lsr r12, r12, #16    //r12=s_ij+1
		mla r5, r2, r12, r5
		mla r6, r2, r14, r6
		lsr r14, r14, #16
		mla r7, r2, r14, r7

		ldmia r1!, {r12,r14}
		mla r8, r2, r12, r8
		lsr r12, r12, #16
		mla r9, r2, r12, r9
		mla r10, r2, r14, r10
		lsr r14, r14, #16
		mla r11, r2, r14, r11

		subs r3, #1	//decrement counter
		bne mul_loop8 //branch if not zero

	pop {r1-r3} //restore: *A_columns, *row_B, row_length
	//store row_B from r4-r11:
	strh r4, [r2, #0]
    strh r5, [r2, #2]
	strh r6, [r2, #4]
	strh r7, [r2, #6]
	strh r8, [r2, #8]
    strh r9, [r2, #10]
	strh r10, [r2, #12]
	strh r11, [r2, #14]

	pop {r4-r12, r14}//restore registers
	bx  lr

