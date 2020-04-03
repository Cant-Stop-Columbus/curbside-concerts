const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

function isDevelopment(options) {
	return options.mode && options.mode === 'development'
}

function isProduction(options) {
	return options.mode && options.mode === 'production'
}

function compact (list) {
  return list.filter(item => item)
}

module.exports = (env, options) => ({
	devtool: isDevelopment(options) ? 'cheap-module-source-map' : undefined,
  optimization: {
    minimizer: [
      new TerserPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
    './js/app.js': glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
			},
			{
				test: /\.css$/,
				include: /node_modules/,
				use: [ 
					MiniCssExtractPlugin.loader,
					'css-loader',
					{
						loader: 'postcss-loader',
						options: {
							plugins: compact([
								isProduction(options) && require('cssnano')()
							])
						}
					}
				]
			},
      {
				test: /\.scss$/,
				exclude: /node_modules/,
        use: [
					MiniCssExtractPlugin.loader,
					'css-loader',
					{
            loader: 'postcss-loader',
            options: {
							plugins: compact([
                require('autoprefixer')(),
                isProduction(options) && require('cssnano')(),
								require('postcss-reporter')()
							]),
              sourceMap: isDevelopment(options)
            }
					},
					{
						loader: 'sass-loader',
						options: {
							sourceMap: isDevelopment(options)
						}
					}
				]
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
	],
	// This setting determines what gets displayed in the console when webpack runs.
  // To see more information, see the options here: https://webpack.js.org/configuration/stats/
  // stats: { all: false, assets: true, colors: true, errors: true, warnings: true },
});
