'use strict'

const webpack = require('webpack');
require('dotenv').config();

module.exports = {
    entry: {
        app: './src/index.js'
    },
    output: {
        path: `${__dirname}/docs`,
        filename: '[name].js'
    },
    module: {
        rules: [
            {
                test: /\.html$/,
                exclude: /node_modules/,
                use: 'file-loader?name=[name].[ext]'
            },
            {
                test: /\.css$/,
                use: [ 'style-loader', 'css-loader' ]
            },
            {
                test: /\.elm$/,
                exclude: [ /node_modules/, /elm-stuff/ ],
                use: 'elm-webpack-loader?debug=true'
            }
        ]
    },
    plugins: [
        new webpack.DefinePlugin({
            API_KEY: JSON.stringify(process.env.API_KEY),
            AUTH_DOMAIN: JSON.stringify(process.env.AUTH_DOMAIN),
            DATABASE_URL: JSON.stringify(process.env.DATABASE_URL),
            PROJECT_ID: JSON.stringify(process.env.PROJECT_ID),
            STORAGE_BUCKET: JSON.stringify(process.env.STORAGE_BUCKET),
            MESSAGING_SENDER_ID: JSON.stringify(process.env.MESSAGING_SENDER_ID)
        })
    ],
    devServer: {
        inline: true,
        stats: 'errors-only'
    }
};
