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

namespace HTTPInspector {
    public class RequestController {
        private List<View.Request> views;
        private RequestStore store;
        public RequestItem? selected_item { get; private set; }
        private int selected_item_idx;
        private Plugins.Engine plugin_engine;
        public signal void start_request ();

        public RequestController () {
            store = new RequestStore ();
            views = new List<View.Request> ();
            plugin_engine = new Plugins.Engine ();
        }

        private void update_views () {
            foreach (var view in views) {
                view.selected_item_updated ();
            }
        }

        public void add_request (RequestItem item) {
            store.add_request (item);
            selected_item = item;
            selected_item.notify.connect (update_views);
            selected_item_idx = store.index_of (item);

            foreach (var view in views) {
                view.new_item (item);
                view.selected_item_changed ();
            }
        }

        public int get_selected_item_idx () {
            return selected_item_idx;
        }

        public void register_view (View.Request view) {
            views.append (view);
        }

        public void update_selected_item (RequestItem item) {
            var idx = store.index_of (item);

            if (idx == -1) {
                stdout.printf ("Invalid item\n");
            }


            plugin_engine.run_request (selected_item);

            selected_item = item;
            selected_item_idx = idx;

            foreach (var view in views) {
                view.selected_item_changed ();
            }
        }

        public bool destroy (RequestItem item) {
            return store.destroy (item);
        }

        public async void perform_request () {
            var action = new RequestAction (selected_item);
            plugin_engine.run_request (selected_item);

            action.finished_request.connect (() => {
                foreach (var view in views) {
                    view.request_completed ();
                }
            });

            start_request ();
            action.make_request ();
        }

        // TODO: Make immutable
        public unowned Gee.ArrayList<RequestItem> get_items () {
            return store.items;
        }
    }
}
