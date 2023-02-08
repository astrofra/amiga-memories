#include "SDL.h"

#define VERSION "0.2.0"
#define WIDTH 320
#define HEIGHT 240
#define TICK_INTERVAL 20
#define SPEED_FACTOR 0.5

// globals
SDL_Surface* screen;

// protos
void DrawSprite( SDL_Surface *surface, int x, int y);
void DrawPlane( SDL_Surface *surface, int time, float scale, int y);
void DrawSky(void);
Uint32 TimeLeft(void);

/*
 * fonctions
 */

void DrawSprite( SDL_Surface *surface, int x, int y)
{
	SDL_Rect destination;

	destination.x = x;
	destination.y = y;

	SDL_BlitSurface( surface, NULL, screen, &destination );
}

void DrawPlane( SDL_Surface *surface, int time, float scale, int y)
{
	int offset;

	offset = (int) ((float) (time * scale * SPEED_FACTOR))%WIDTH;

	DrawSprite( surface, offset - WIDTH, y );
	DrawSprite( surface, offset, y );
}

void DrawSky(void)
{
	SDL_Rect r;
	
	r.x = 0;
	r.w = WIDTH;
	r.y = 0;
	r.h = 76;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 99, 113, 132) );
	r.y += r.h;
	r.h = 27;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 115, 113, 132) );
	r.y += r.h;
	r.h = 14;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 132, 113, 132) );
	r.y += r.h;
	r.h = 10;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 148, 113, 132) );
	r.y += r.h;
	r.h = 8;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 165, 113, 132) );
	r.y += r.h;
	r.h = 7;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 181, 113, 132) );
	r.y += r.h;
	r.h = 6;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 198, 113, 132) );
	r.y += r.h;
	r.h = 6;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 214, 113, 132) );
	r.y += r.h;
	r.h = 4;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 231, 113, 132) );
	r.y += r.h;
	r.h = 6;
	SDL_FillRect( screen, &r, SDL_MapRGB(screen->format, 247, 113, 132) );
}

Uint32 TimeLeft(void)
{
	static Uint32 next_time = 0;
	Uint32 now;

	now = SDL_GetTicks();
	if ( next_time <= now )
	{
        	next_time = now + TICK_INTERVAL;
		return(0);
	}
	return(next_time - now);
}

/*
 * le main
 */

int main(int argc, char* argv[])
{
	SDL_Event event;
	SDL_Surface* herbe0;
	SDL_Surface* herbe1;
	SDL_Surface* herbe2;
	SDL_Surface* herbe3;
	SDL_Surface* herbe4;
	SDL_Surface* nuages0;
	SDL_Surface* nuages1;
	SDL_Surface* nuages2;
	SDL_Surface* nuages3;
	SDL_Surface* nuages4;
	SDL_Surface* barriere;
	SDL_Surface* montagnes;
	SDL_Surface* lune;
	int exitkey = 0;
	int iScroll = 0;

	if( SDL_Init(SDL_INIT_VIDEO) < 0 )
	{
		fprintf(stderr, "Could not initialize SDL: %s\n", SDL_GetError());
		return -1;
	}

	atexit(SDL_Quit);

	// screen = SDL_SetVideoMode(WIDTH, HEIGHT, 32, SDL_HWSURFACE|SDL_DOUBLEBUF|SDL_FULLSCREEN);
	screen = SDL_SetVideoMode(WIDTH, HEIGHT, 32, SDL_HWSURFACE|SDL_DOUBLEBUF);

	if( !screen )
	{
		fprintf(stderr, "Couldn't create a surface: %s\n", SDL_GetError());
		return -1;
	}

	printf("Shadow of the Blitz %s\n", VERSION);
	printf("http://www.glop.org/software/sotb\n");
	printf("\n");
	printf("Created SDL Surface: %x\n", screen);
	printf("Resolution used: %dx%dx%d\n", screen->w, screen->h, screen->format->BytesPerPixel * 8);

	herbe0 = SDL_LoadBMP("data/herbe0.bmp");
	herbe1 = SDL_LoadBMP("data/herbe1.bmp");
	herbe2 = SDL_LoadBMP("data/herbe2.bmp");
	herbe3 = SDL_LoadBMP("data/herbe3.bmp");
	herbe4 = SDL_LoadBMP("data/herbe4.bmp");

	nuages0 = SDL_LoadBMP("data/nuages0.bmp");
	SDL_SetColorKey(nuages0, SDL_SRCCOLORKEY, SDL_MapRGB(nuages0->format, 0xFF, 0x00, 0xFF) );
	nuages1 = SDL_LoadBMP("data/nuages1.bmp");
	SDL_SetColorKey(nuages1, SDL_SRCCOLORKEY, SDL_MapRGB(nuages1->format, 0xFF, 0x00, 0xFF) );
	nuages2 = SDL_LoadBMP("data/nuages2.bmp");
	SDL_SetColorKey(nuages2, SDL_SRCCOLORKEY, SDL_MapRGB(nuages2->format, 0xFF, 0x00, 0xFF) );
	nuages3 = SDL_LoadBMP("data/nuages3.bmp");
	SDL_SetColorKey(nuages3, SDL_SRCCOLORKEY, SDL_MapRGB(nuages3->format, 0xFF, 0x00, 0xFF) );
	nuages4 = SDL_LoadBMP("data/nuages4.bmp");
	SDL_SetColorKey(nuages4, SDL_SRCCOLORKEY, SDL_MapRGB(nuages4->format, 0xFF, 0x00, 0xFF) );

	barriere = SDL_LoadBMP("data/barriere.bmp");
	SDL_SetColorKey(barriere, SDL_SRCCOLORKEY, SDL_MapRGB(barriere->format, 0xFF, 0x00, 0xFF) );
	montagnes = SDL_LoadBMP("data/montagnes.bmp");
	SDL_SetColorKey(montagnes, SDL_SRCCOLORKEY, SDL_MapRGB(montagnes->format, 0xFF, 0x00, 0xFF) );
	lune = SDL_LoadBMP("data/lune.bmp");
	SDL_SetColorKey(lune, SDL_SRCCOLORKEY, SDL_MapRGB(lune->format, 0xFF, 0x00, 0xFF) );

	while(!exitkey)
	{
		/* Lock the screen, if needed */
		if(SDL_MUSTLOCK(screen)) {
			if(SDL_LockSurface(screen) < 0)
				return;
		}

		//SDL_FillRect( screen, NULL, SDL_MapRGB(screen->format,0,0,0) );

		DrawSky();

		DrawSprite( lune, 184, 16);

		DrawPlane( montagnes, iScroll, (float) 1, 97);
		DrawPlane( herbe0, iScroll, (float) 2, 170);
		DrawPlane( herbe1, iScroll, (float) 3, 172);
		DrawPlane( herbe2, iScroll, (float) 4, 175);
		DrawPlane( herbe3, iScroll, (float) 5, 182);
		DrawPlane( herbe4, iScroll, (float) 6, 189);
		DrawPlane( barriere, iScroll, (float) 7, 179);

		DrawPlane( nuages0, iScroll, (float) 2, 0);
		DrawPlane( nuages1, iScroll, (float) 1, 22);
		DrawPlane( nuages2, iScroll, (float) 1/2, 63);
		DrawPlane( nuages3, iScroll, (float) 1/3, 82);
		DrawPlane( nuages4, iScroll, (float) 1/4, 91);

		/* Ulock the screen, if needed */
		if(SDL_MUSTLOCK(screen)) {
			SDL_UnlockSurface(screen);
		}

		SDL_Flip( screen );
		SDL_Delay(TimeLeft());

		//iScroll = (iScroll + 1) % (WIDTH * 2);
		iScroll++;
		//printf("Scroll : %d\n", iScroll );

		// events
		while(SDL_PollEvent(&event))
		{
			switch(event.type)
			{
				case SDL_QUIT:
					exitkey = 1;
					printf("Got quit event, exiting.\n");
					break;
				case SDL_KEYDOWN:
					switch(event.key.keysym.sym)
					{
						case SDLK_ESCAPE:
							printf("ESC key hit, exiting.\n");
							exitkey = 1;
							break;
						case SDLK_f:
							printf("switching fullscreen\n");
							SDL_WM_ToggleFullScreen(screen);
							break;
					}
			}
		}
	}
	
	return 0;
}
