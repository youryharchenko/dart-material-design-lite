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

part of mdlremote;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _MaterialMustacheCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    const _MaterialMustacheCssClasses();
}

/// Store constants in one place so they can be updated easily.
class _MaterialMustacheConstant {
    const _MaterialMustacheConstant();
}

/// registration-Helper
void registerMaterialMustache() => componenthandler.register(new MdlWidgetConfig<MaterialMustache>(
    "mdl-js-mustache", (final html.HtmlElement element) => new MaterialMustache.fromElement(element)));

class MaterialMustache extends MdlComponent {
    final Logger _logger = new Logger('mdlremote.MaterialMustache');

    static const _MaterialMustacheConstant _constant = const _MaterialMustacheConstant();
    static const _MaterialMustacheCssClasses _cssClasses = const _MaterialMustacheCssClasses();

    final Renderer _renderer = new Renderer();

    String _template = "";

    MaterialMustache.fromElement(final html.HtmlElement element) : super(element) {
        _init();
    }

    static MaterialMustache widget(final html.HtmlElement element) => mdlComponent(element) as MaterialMustache;

    // Central Element - by default this is where mdl-js-mustache was found (element)
    // html.Element get hub => inputElement;

    void set template(final String value) {
        _template = value.trim().replaceAll(new RegExp(r"\s+")," ");
    }

    Future render(final scope) {
        //_logger.info("Content: $content");

        final Template mustacheTemplate = new Template(_template,htmlEscapeValues: false);
        return _renderer.render(element,mustacheTemplate.renderString(scope));
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("MaterialMustache - init");
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

