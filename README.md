
### Install dependencies
`yarn install`

### Start a local chain
`yarn chain`

### Setup the contracts
With your local chain still running, run:
`yarn deploy`

First, run the development server:
`yarn dev`

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `pages/index.tsx`. The page auto-updates as you edit the file.

[API routes](https://nextjs.org/docs/api-routes/introduction) can be accessed on [http://localhost:3000/api/hello](http://localhost:3000/api/hello). This endpoint can be edited in `pages/api/hello.tsx`.

The `pages/api` directory is mapped to `/api/*`. Files in this directory are treated as [API routes](https://nextjs.org/docs/api-routes/introduction) instead of React pages.

## Deploying to Other Environments
You can run target any network by appending `--network <network_name>` to any of the previous commands.

For example, to deploy to mainnet you would run:
`yarn deploy --network mainnet`

And to populate an existing Blitnaut contract on Rinkeby you would run:
`yarn deploy --network rinkeby`
