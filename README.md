# JSTemplatesViewEngine

This is for rendering any javascript template engines from swift.

## Usage

### 1. Prepare the template file

Here is a mustache template file that has a `@__js_templates_view_engine_temlate_data__` token.
It is replaced to the JSON serialized templateData that passed from Swift

**/views/index.mustache**
```html
<!DOCTYPE html>
    <html lang="ja">
    <head>
        <meta charset="utf-8">
        <script src="https://code.jquery.com/jquery-2.2.3.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/2.2.1/mustache.js"></script>
        <script>
          function load() {
            // Here is important to get templateData from Swift
            var data = @__js_templates_view_engine_temlate_data__;


            var template = $('#template').html();
            Mustache.parse(template);
            var rendered = Mustache.render(template, data);
            $('#target').html(rendered);
          }

          $(document).ready(function(){
            load();
          });

        </script>
    </head>
    <body>
      <div id="target">Loading...</div>
      <script id="template" type="x-tmpl-mustache">
        <p>Welcome to {{ name }} !</p>
      </script>
    </body>
</html>

```

### 2. Call `Render` with `JSTemplatesViewEngine` in Your App

**app.swift**
```swift
import Slimane

let app = Slimane()

app.get("/") { req, responder in
  responder {
      let render = Render(engine: JSTemplatesViewEngine(templateData: ["name": "Slimane"]), path: "index.mustache")
      Response(custome: render)
  }
}

try! app.listen()
```


### And then...

`@__js_templates_view_engine_temlate_data__` is replaced to the JSON

```html
<!DOCTYPE html>
    <html lang="ja">
    <head>
        <meta charset="utf-8">
        <script src="https://code.jquery.com/jquery-2.2.3.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/2.2.1/mustache.js"></script>
        <script>
          function load() {
            // Here is important to get templateData from Swift
            var data ={"name": "Slimane"};


            var template = $('#template').html();
            Mustache.parse(template);
            var rendered = Mustache.render(template, data);
            $('#target').html(rendered);
          }

          $(document).ready(function(){
            load();
          });

        </script>
    </head>
    <body>
      <div id="target">Loading...</div>
      <script id="template" type="x-tmpl-mustache">
        <p>Welcome to {{ name }} !</p>
      </script>
    </body>
</html>

```


## Package.swift
```swift
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .Package(url: "https://github.com/slimane-swift/JSTemplatesViewEngine.git", majorVersion: 0, minor: 1),
    ]
)
```
