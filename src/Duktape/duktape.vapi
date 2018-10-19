/*
* Copyright (c) 2018 Marvin Ahlgrimm (https://github.com/treagod)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Marvin Ahlgrimm <marv.ahlgrimm@gmail.com>
*/

[CCode (lower_case_cprefix = "duk_", cheader_filename = "duktape.h")]
namespace Duktape {
    [CCode (cname = "duk_context", free_function = "duk_destroy_heap")]
    [Compact]
    public class Context {
        [CCode (cname = "duk_create_heap_default")]
        public Context ();

        [CCode (cname = "duk_eval_string")]
        public void eval_string (string src);

        [CCode (cname = "duk_push_string")]
        public void push_string (string str);

        [CCode (cname = "duk_push_lstring")]
        public void push_lstring (string str, int length);

        [CCode (cname = "duk_push_number")]
        public void push_number (double number);

        [CCode (cname = "duk_push_int")]
        public void push_int (int i);

        [CCode (cname = "duk_push_true")]
        public void push_true ();

        [CCode (cname = "duk_push_false")]
        public void push_false ();

        [CCode (cname = "duk_push_nan")]
        public void push_nan ();

        [CCode (cname = "duk_push_null")]
        public void push_null ();

        [CCode (cname = "duk_push_object")]
        public int push_object ();

        [CCode (cname = "duk_put_prop_string")]
        public void put_prop_string (int idx, string str);

        [CCode (cname = "duk_put_global_string")]
        public void put_global_string (string str);

        [CCode (cname = "duk_push_c_function")]
        public int push_vala_function(ValaFunction func, int nargs);

        [CCode (cname = "duk_push_array")]
        public uint push_array();

        [CCode (cname = "duk_insert")]
        public void insert (int idx);

        [CCode (cname = "duk_join")]
        public void join (int count);

        [CCode (cname = "duk_get_top")]
        public int get_top ();

        [CCode (cname = "duk_safe_to_string")]
        public unowned string safe_to_string (int idx);

        [CCode (cname = "duk_pop")]
        public void pop();

        [CCode (cname = "duk_get_global_string")]
        public void get_global_string (string name);

        [CCode (cname = "duk_call")]
        public void call (uint nargs);
    }

    [CCode (cprefix = "DUK_RET_", cname = "int")]
    public enum ReturnType {
        ERROR,
        EVAL_ERROR,
        RANGE_ERROR,
        REFERENCE_ERROR,
        SYNTAX_ERROR,
        TYPE_ERROR,
        URI_ERROR
    }

    [CCode (cname = "duk_c_function", has_target = false)]
    public delegate ReturnType ValaFunction (Context ctx);

    [CCode (cname = "DUK_VARARGS")]
    public int VARARGS;
}
