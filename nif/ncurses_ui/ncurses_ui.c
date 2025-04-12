#include <stdlib.h>
#include <curses.h>
#include <signal.h>
#include <erl_nif.h>

static void finish(int sig);
static int inited = 0;

static void
init()
{
    if (inited) return;
    /* initialize your non-curses data structures here */

    signal(SIGINT, finish);      /* arrange interrupts to terminate */

    initscr();      /* initialize the curses library */
    keypad(stdscr, TRUE);  /* enable keyboard mapping */
    nonl();         /* tell curses not to do NL->CR/NL on output */
    cbreak();       /* take input chars one at a time, no wait for \n */
    echo();         /* echo input - in color */

    if (has_colors())
    {
        start_color();

        /*
         * Simple color assignment, often all we need.  Color pair 0 cannot
         * be redefined.  This example uses the same value for the color
         * pair as for the foreground color, though of course that is not
         * necessary:
         */
        init_pair(1, COLOR_RED,     COLOR_BLACK);
        init_pair(2, COLOR_GREEN,   COLOR_BLACK);
        init_pair(3, COLOR_YELLOW,  COLOR_BLACK);
        init_pair(4, COLOR_BLUE,    COLOR_BLACK);
        init_pair(5, COLOR_CYAN,    COLOR_BLACK);
        init_pair(6, COLOR_MAGENTA, COLOR_BLACK);
        init_pair(7, COLOR_WHITE,   COLOR_BLACK);
    }

    inited = 1;
}

static void
step() {
    int num = 0;
    for (;;)
    {
        int c = getch();     /* refresh, accept single keystroke of input */
        attrset(COLOR_PAIR(num % 8));
        num++;
        /* process the command keystroke */
    }
}

static void
finish(int sig)
{
    endwin();

    /* do your non-curses wrapup here */

    exit(0);
}

static ERL_NIF_TERM
init_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    init();
    return enif_make_int(env, 0);
}

static ERL_NIF_TERM
step_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    step();
    return enif_make_int(env, 0);
}

static ErlNifFunc nif_funcs[] = {
    {"ui_init", 0, init_nif},
    {"ui_step", 0, step_nif},
};

ERL_NIF_INIT(Elixir.CursesUI, nif_funcs, NULL, NULL, NULL, NULL);
