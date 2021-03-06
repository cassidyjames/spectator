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

namespace Spectator.Widgets.Response {
    class SourceView : Gtk.SourceView {
        public new Gtk.SourceBuffer buffer;
        public Gtk.SourceLanguageManager manager;
        public Gtk.SourceStyleSchemeManager style_scheme_manager;

        private string font { set; get; default = "Roboto Mono Regular 11"; }

        private Gtk.SourceLanguage? language {
            set {
                buffer.language = value;
            }
        }

        public void set_lang (string lang) {
            language = manager.get_language (lang);
        }

        public SourceView () {
            Object (
                highlight_current_line: false,
                show_right_margin: false,
                wrap_mode: Gtk.WrapMode.WORD_CHAR
            );
        }

        public void insert_text (string res) {
            try {
               buffer.text = convert_with_fallback (res, res.length, "UTF-8", "ISO-8859-1");
           } catch (ConvertError e) {
               stderr.printf ("Error converting markup for" + res + ", "+ e.message);
           }
        }

        public void insert (ResponseItem? res) {
            if (res == null) {
                buffer.text = "";
            }

            try {
                buffer.text = convert_with_fallback (res.data, res.data.length, "UTF-8", "ISO-8859-1");
            } catch (ConvertError e) {
                stderr.printf ("Error converting markup for" + res.data + ", "+ e.message);
            }
        }

        construct {
            manager = Gtk.SourceLanguageManager.get_default ();
            editable = false;
            style_scheme_manager = new Gtk.SourceStyleSchemeManager ();
            var style_id = (Gtk.Settings.get_default ().gtk_application_prefer_dark_theme) ? "solarized-dark" : "solarized-light";
            var scheme = style_scheme_manager.get_scheme (style_id);

            Settings.get_instance ().theme_changed.connect (() => {
                var temp_id = (Gtk.Settings.get_default ().gtk_application_prefer_dark_theme) ? "solarized-dark" : "solarized-light";
                var schem = style_scheme_manager.get_scheme (temp_id);
                buffer.style_scheme = schem;
            });

            buffer = new Gtk.SourceBuffer (null);
            buffer.highlight_syntax = true;
            buffer.style_scheme = scheme;

            set_buffer (buffer);
            set_show_line_numbers (false);

            language = manager.get_language ("html");
        }
    }
}
