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

namespace HTTPInspector.Widgets.Sidebar {
    public class Item : Gtk.FlowBoxChild {
        static string no_url = "<small><i>No URL specified</i></small>";
        Gtk.EventBox item_box { get; set;}
        Gtk.Label method;
        Gtk.Label request_name;
        Gtk.Label url;
        public RequestItem item { get; set; }
        public signal void item_deleted (RequestItem item);
        public signal void item_edit (RequestItem item);

        private string get_method_label(Method method) {
            var dark_theme = Gtk.Settings.get_default ().gtk_application_prefer_dark_theme;
            switch (method) {
                case Method.GET:
                    var color = dark_theme ? "64baff" : "0d52bf";
                    return "<span color=\"#" + color + "\">GET</span>";
                case Method.POST:
                    var color = dark_theme ? "9bdb4d" : "3a9104";
                    return "<span color=\"#" + color + "\">POST</span>";
                case Method.PUT:
                    var color = dark_theme ? "ffe16b" : "ad5f00";
                    return "<span color=\"#" + color + "\">PUT</span>";
                case Method.PATCH:
                    var color = dark_theme ? "ffa154" : "cc3b02";
                    return "<span color=\"#" + color + "\">PATCH</span>";
                case Method.DELETE:
                    var color = dark_theme ? "ed5353" : "a10705";
                    return "<span color=\"#" + color + "\">DELETE</span>";
                case Method.HEAD:
                    var color = dark_theme ? "ad65d6" : "4c158a";
                    return "<span color=\"#" + color + "\">HEAD</span>";
                default:
                    assert_not_reached ();
            }
        }

        public Item (RequestItem it) {
            item = it;
            item.notify.connect (() => {
                refresh ();
            });
            item_box = new Gtk.EventBox ();
            var info_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            request_name = new Gtk.Label (item.name);
            request_name.halign = Gtk.Align.START;
            request_name.ellipsize = Pango.EllipsizeMode.END;

            url = new Gtk.Label ("");
            url.halign = Gtk.Align.START;
            url.use_markup = true;
            url.ellipsize = Pango.EllipsizeMode.END;

            set_formatted_uri (item.uri);

            info_box.add (request_name);
            info_box.add (url);
            info_box.has_tooltip = true;

            info_box.query_tooltip.connect ((x, y, keyboard_tooltip, tooltip) => {
                if (item.uri == "") {
                    return false;
                }
                tooltip.set_text (item.uri);
                return true;
            });

            create_box_menu ();

            method = new Gtk.Label (get_method_label (item.method));
            method.set_justify (Gtk.Justification.CENTER);
            method.halign = Gtk.Align.END;
            method.margin_left = 10;
            method.margin_end = 10;
            method.use_markup = true;

            var container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            container.margin = 4;

            container.pack_start (info_box, true, true, 0);
            container.pack_end (method, true, true, 2);

            item_box.add (container);

            add (item_box);
        }

        public void update (RequestItem it) {
            item = it;
            method.label = get_method_label (item.method);

            request_name.label = item.name;

            set_formatted_uri (item.uri);

            show_all ();
        }

        private void set_formatted_uri (string uri) {
            if (item.uri.length > 0) {
                url.label = "<small><i>" + escape_url (uri) + "</i></small>";
            } else {
                url.label = no_url;
            }
        }

        private void create_box_menu () {
            item_box.button_release_event.connect ((event) => {
                if (event.button == 3) {
                    var menu = new Gtk.Menu ();
                    var edit_item = new Gtk.MenuItem.with_label ("Edit");
                    var delete_item = new Gtk.MenuItem.with_label ("Delete");

                    edit_item.activate.connect (() => {
                        item_edit (item);
                    });

                    delete_item.activate.connect (() => {
                        item_deleted (item);
                    });

                    menu.add (edit_item);
                    menu.add (delete_item);
                    menu.show_all ();
                    menu.popup_at_pointer (event);

                    return true;
                }
                return false;
            });
        }

        public void refresh () {
            method.label = get_method_label (item.method);

            request_name.label = item.name;

            var escaped_url = escape_url (item.uri);
            if (item.uri.length > 0) {
                url.label = "<small><i>" + escaped_url + "</i></small>";
            } else {
                url.label = no_url;
            }

            show_all ();
        }

        private string escape_url (string url) {
            var escaped_url = url;
            escaped_url = escaped_url.replace ("&", "&amp;");
            escaped_url = escaped_url.replace ("\"", "&quot;");
            escaped_url = escaped_url.replace ("<", "&lt;");
            escaped_url = escaped_url.replace (">", "&gt;");
            return escaped_url;
        }
    }
}
