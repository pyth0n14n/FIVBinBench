/**************************************************************************/
/*                                                                        */
/*  This file is part of FISSC.                                           */
/*                                                                        */
/*  You can redistribute it and/or modify it under the terms of the GNU   */
/*  Lesser General Public License as published by the Free Software       */
/*  Foundation, version 3.0.                                              */
/*                                                                        */
/*  It is distributed in the hope that it will be useful,                 */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of        */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         */
/*  GNU Lesser General Public License for more details.                   */
/*                                                                        */
/*  See the GNU Lesser General Public License version 3.0                 */
/*  for more details (enclosed in the file LICENSE).                      */
/*                                                                        */
/**************************************************************************/

/*$
  @name = VerifyPIN_0
  @feature = verifyPIN
  @fault-model = test-inversion
  @attack-scenario = oracle
  @countermeasure = none
  @maintainers = Etienne Boespflug, VERIMAG
  @authors = Lionel Rivière, SERTIF Consortium
  @version 2.2
*/

// #include <stdio.h>

#include "interface.h"
#include "types.h"
#include "lazart.h"
#ifdef PRINTF
#include <stdio.h>
#endif

extern UBYTE g_countermeasure;
extern BOOL g_authenticated;
extern SBYTE g_ptc;

BOOL verifyPIN(void);

volatile void __attribute__((noinline)) super_secret_function()
{
	return;
    // while (1)
    // {
    // }
}

//----------------
typedef void (*vector_table_entry_t)(void);

typedef struct {
	unsigned int *initial_sp_value; /**< Initial stack pointer value. */
	vector_table_entry_t reset;
	vector_table_entry_t nmi;
	vector_table_entry_t hard_fault;
	vector_table_entry_t memory_manage_fault; /* not in CM0 */
	vector_table_entry_t bus_fault;           /* not in CM0 */
	vector_table_entry_t usage_fault;         /* not in CM0 */
	vector_table_entry_t reserved_x001c[4];
	vector_table_entry_t sv_call;
	vector_table_entry_t debug_monitor;       /* not in CM0 */
	vector_table_entry_t reserved_x0034;
	vector_table_entry_t pend_sv;
	vector_table_entry_t systick;
	vector_table_entry_t irq[0];
} vector_table_t;

extern vector_table_t vector_table;
//----------------


int main()
{
    initialize();
    verifyPIN();
    LAZART_ORACLE(oracle());

#ifdef PRINTF
    printf("[@] g_countermeasure = %i, g_authenticated = %x, g_ptc = %i\n", g_countermeasure, g_authenticated, g_ptc);
#endif
	if (g_authenticated) {
		super_secret_function();
	}
    return 0;
}

//------------------
void reset_handler(void) {
    main();

    while(1) {
	__asm__("nop");
    }
}

__attribute__ ((section(".vectors")))
vector_table_t vector_table = {
	.initial_sp_value = (unsigned *)0x20002000,
	.reset = reset_handler
};
//------------------