import * as esbuild from 'esbuild'

let ctx = await esbuild.context({
  entryPoints: ['app/javascript/*.js'],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  external: ['@hotwired/stimulus-loading'],
  // CSSを処理するための設定を追加
  loader: {
    '.css': 'css'
  }
})

if (process.argv.includes('--watch')) {
  await ctx.watch()
  console.log('Watching...')
} else {
  await ctx.rebuild()
  await ctx.dispose()
}
