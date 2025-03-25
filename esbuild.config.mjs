import * as esbuild from 'esbuild'
import { sassPlugin } from 'esbuild-sass-plugin'

let ctx = await esbuild.context({
  entryPoints: ['app/javascript/*.js'],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  plugins: [sassPlugin()],
  external: ['@hotwired/stimulus-loading'],
})

if (process.argv.includes('--watch')) {
  await ctx.watch()
  console.log('Watching...')
} else {
  await ctx.rebuild()
  await ctx.dispose()
}
