#include "headers.h"

/* ---------------------------------------------------------------------------- *
 * 									main()										*
 * ---------------------------------------------------------------------------- *
 * Runs all initial setup functions to initialise the audio codec and IP
 * peripherals, before calling the interactive menu system.
 * ---------------------------------------------------------------------------- */
int main(void)
{
	//Configure the IIC data structure
	IicConfig(XPAR_XIICPS_0_DEVICE_ID);
	//Configure the Audio Codec's PLL
	AudioPllConfig();
	
	//Configure all audio registers
	//AudioConfigureJacks();
	LineinLineoutConfig();

	//stream audio
	audio_stream();

    return 1;
}

