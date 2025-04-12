#include <stdlib.h>
#include <curses.h>
#include <signal.h>
#include <erl_nif.h>

static void finish(int sig);
static int inited = 0;
static int screen_width = 0;
static int screen_height = 0;

static void
init(int width, int height)
{
    if (inited) return;

    screen_width = width;
    screen_height = height;

    signal(SIGINT, finish);        /* arrange interrupts to terminate */

    initscr();        /* initialize the curses library */
    keypad(stdscr, TRUE);    /* enable keyboard mapping */
    nonl();         /* tell curses not to do NL->CR/NL on output */
    cbreak();         /* take input chars one at a time, no wait for \n */
    echo();         /* echo input - in color */

    if (has_colors())
    {
        start_color();

        /*
         * Simple color assignment, often all we need.    Color pair 0 cannot
         * be redefined.    This example uses the same value for the color
         * pair as for the foreground color, though of course that is not
         * necessary:
         */
        init_pair(1, COLOR_GREEN, COLOR_BLACK);
        init_pair(2, COLOR_BLACK, COLOR_GREEN);
        init_pair(3, COLOR_RED, COLOR_BLACK);
    }

    inited = 1;
}

static void
step() {
    refresh();
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
    int w, h;
    if (!enif_get_int(env, argv[0], &w)
        || !enif_get_int(env, argv[1], &h))
        return enif_make_badarg(env);

    init(w, h);
    return enif_make_atom(env, "ok");
}

static ERL_NIF_TERM
step_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    step();
    return enif_make_atom(env, "ok");
}

static ERL_NIF_TERM
draw_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ERL_NIF_TERM screen_buffer = argv[0];

    if (!enif_is_map(env, screen_buffer)) {
        return enif_make_badarg(env);
    }

    for (int y = 0; y < screen_height; y++) {
        for (int x = 0; x < screen_width; x++) {
            ERL_NIF_TERM key = enif_make_int(env, y * screen_width + x);
            ERL_NIF_TERM value;

            if (!enif_get_map_value(env, screen_buffer, key, &value)) {
                return enif_make_badarg(env);
            }
            int c;
            enif_get_int(env, value, &c);
            c += 1; // 0 -> 1, 1 -> 2
            if (c >= 3) c = 3;
            attron(COLOR_PAIR(c));
            mvprintw(y, x*2, "  ");
            attroff(COLOR_PAIR(c));
        }
    }

    return enif_make_int(env, 0);
}

static ErlNifFunc nif_funcs[] = {
    {"ui_init", 2, init_nif},
    {"ui_step", 0, step_nif},
    {"ui_draw", 1, draw_nif},
};

ERL_NIF_INIT(Elixir.CursesUI, nif_funcs, NULL, NULL, NULL, NULL);
