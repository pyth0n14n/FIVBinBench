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

#include <stdio.h>

#include "interface.h"
#include "types.h"
#include "lazart.h"

#ifdef FAULT_INJECTION_SIMULATOR
#include "faultconfig.h"
#endif

#ifdef SLEEP
#include <unistd.h>
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

int main()
{
#ifdef SLEEP
    usleep(1000000);
#endif

    initialize();
    verifyPIN();
    LAZART_ORACLE(oracle());

    printf("[@] g_countermeasure = %i, g_authenticated = %x, g_ptc = %i\n", g_countermeasure, g_authenticated, g_ptc);
#ifdef FAULT_INJECTION_SIMULATOR
    if (g_authenticated) return 0;
    else return -1;
#endif
	if (g_authenticated) {
		super_secret_function();
	}
    return 0;
}


#ifdef FAULT_INJECTION_SIMULATOR
FAULT_CONFIG("TIMEOUT=10");
FAULT_CONFIG("NOASLR");
// FAULT_CONFIG_ENTRY(main);
FAULT_CONFIG_ENTRY(_start);
#endif