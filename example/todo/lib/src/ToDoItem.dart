/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of todo;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _ToDoItemComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    const _ToDoItemComponentCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _ToDoItemComponentConstant {
    const _ToDoItemComponentConstant();
}

/// registration-Helper
void registerToDoItemComponent() => componenthandler.register(new MdlWidgetConfig<ToDoItemComponent>(
    "todo-items", (final dom.HtmlElement element) => new ToDoItemComponent.fromElement(element)));

@MdlComponentModel
class ToDoItem {
    final Logger _logger = new Logger('todo.ToDoItem');

    static int counter = 0;
    int id;

    bool checked;
    final String item;

    ToDoItem(this.checked, this.item) : id = counter { counter++; }
}

@MdlComponentModel
class ToDoItemComponent extends MdlTemplateComponent {
    final Logger _logger = new Logger('todo.ToDoItemComponent');

    //static const _ToDoItemConstant _constant = const _ToDoItemConstant();
    static const _ToDoItemComponentCssClasses _cssClasses = const _ToDoItemComponentCssClasses();

    final List<ToDoItem> _items = new List<ToDoItem>();

    ToDoItemComponent.fromElement(final dom.HtmlElement element) : super(element) {
        _init();
    }

    static ToDoItemComponent widget(final dom.HtmlElement element) => mdlComponent(element) as ToDoItemComponent;

    String template = """
        <div>
            <ul>
                {{#items}}
                    <li>
                        <div class="row">
                            <label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="check{{id}}">
                                {{#checked}}
                                    <input type="checkbox" id="check{{id}}" class="mdl-checkbox__input" checked data-mdl-click="check({{id}})"/>
                                {{/checked}}
                                {{^checked}}
                                    <input type="checkbox" id="check{{id}}" class="mdl-checkbox__input" data-mdl-click="check({{id}})"/>
                                {{/checked}}
                                <span class="mdl-checkbox__label">{{item}}</span>
                            </label>
                            <button class="mdl-button mdl-js-button mdl-button--colored mdl-js-ripple-effect"
                                data-mdl-click="remove({{id}})">
                                Remove
                            </button>
                        </div>
                    </li>
                {{/items}}
            </ul>
        </div>
        """.trim().replaceAll(new RegExp(r"\s+")," ");



    List<ToDoItem> get items => _items;

    void addItem(final ToDoItem value) {
        _items.add(value);
        render();
    }

    void remove(final String id) {
        _logger.info("Click $id");
        _items.remove(getItem(id));
        render();
    }

    void check(final String id) {
        _logger.info("Check $id");

        final MaterialCheckbox checkbox = MaterialCheckbox.widget(element.querySelector("#check${id.trim()}"));
        final ToDoItem item = getItem(id);
        item.checked = checkbox.checked;
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("ToDoItem - init");
        element.classes.add(_cssClasses.IS_UPGRADED);

        _items.add(new ToDoItem(false,"Mike"));
        _items.add(new ToDoItem(true,"Gerda"));
        _items.add(new ToDoItem(false,"Sarah"));

        render();
    }

    ToDoItem getItem(final String id) {
        for(int counter = 0;counter < _items.length;counter++) {
            if(_items[counter].id == int.parse(id)) {
                return _items[counter];
            }
        }
        return null;
    }
}

