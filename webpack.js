'use strict';
const webpack = require('webpack');
const path = require('path');
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  entry: {
    'shiny': [ './src/scss/_build.scss' ]
  },
  output: {
    path: path.resolve('./www/'),
    clean: true
  },
  mode: 'production',
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          {
            loader: 'css-loader',
            options: {
              sourceMap: true,
              url: false,
            },
          },
          {
            loader: 'sass-loader',
            options: {
              implementation: require('sass')
            }
          }
        ]
      }
    ]
  },
  plugins: [
    // shiny.css
    new MiniCssExtractPlugin(),

    // clean up
    new RemoveEmptyScriptsPlugin(),
  ]
};
