## aang-template-brunch 1.7.3

[<img src="https://david-dm.org/jupl/aang-template-brunch.png"/>](https://david-dm.org/jupl/aang-template-brunch)
[<img src="https://david-dm.org/jupl/aang-template-brunch/dev-status.png"/>](https://david-dm.org/jupl/aang-template-brunch#info=devDependencies)

Compile static HTML or Jade files to Angular templates. This plugin scans `.html` or `.jade` files (except in assets) and returns JavaScript in a format similar to this:

```javascript
angular.module('app').run(['$templateCache', function($templateCache) {
  $templateCache.put('template/header.html', '<div>Title</div>');
}]);
```

Make sure you have the module (default is `app`) defined in your JavaScript before templates are declared. (see `config.files.order.before`)


## Config
You can change the behavior of this plugin by using These are the default options

```javascript
angularTemplate: {
  moduleName: 'app',
  pathToSrc: function(x) { return x },
  jadeOptions: {},
  ignore: []
}
```

### `moduleName`
The name of an established Angular module. This module will be used to access `$templateCache`. The default value is `app`.

### `pathToSrc`
A function to be able to transform the path of the file. (ex: `app/templates/sample.html`) The default value is a function that just returns the path without modification.

### `jadeOptions`
Local data that can be injected into Jade templates when compiling. The default value is an empty object.

### `ignore`
A function/regex/string or an array of functions/regexs/strings that can be used to define files that do not get compiled. (ex: `app/outdated/old.html`) Default is an empty array. (no ignoring)


## Usage
Add `"aang-template-brunch": "x.y.z"` to `package.json` of your brunch app.

Pick a plugin version that corresponds to your minor (y) brunch version.

If you want to use git version of plugin, add
`"aang-template-brunch": "git+ssh://git@github.com:jupl/aang-template-brunch.git"`.
