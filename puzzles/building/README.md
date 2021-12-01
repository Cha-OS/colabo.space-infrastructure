[Authoring Libraries](https://webpack.js.org/guides/author-libraries/)

https://stackoverflow.com/questions/41359740/how-to-bundle-a-library-with-webpack

```js
module.exports = {
	// It should be a single entry
	entry: "./index.ts",
	// ...
	output: {
		// we need to specify single output
		filename: `${libraryName}.js`,

		// we need to specify the library
		library: {
			name: `${libraryName}`,
			type: 'umd',
		},

		path: path.resolve(__dirname, "build"),
	},
```

[Webpack example](/colabo/src/backend/dev_puzzles/knalledge/core/webpack.config.js)
[tsconfig.json example](/colabo/src/backend/dev_puzzles/knalledge/core/tsconfig.json)
[config file for importing module](colabo/src/backend/apps/colabo-space/config/global.js)
+ `registerModules` under `globalSet.puzzles["@colabo-knalledge/b-core"]`

# TODO

Load the output name from the `package.json` and convert all problematic characters: `@colabo-knalledge/b-core` -> `colabo_knalledge__b_core`
