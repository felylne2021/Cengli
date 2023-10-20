import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import { nodePolyfills } from 'vite-plugin-node-polyfills'
import builtins from 'rollup-plugin-node-builtins'

const builtinsPlugin = builtins({
  crypto: true,
})


export default defineConfig({
  plugins: [react(), nodePolyfills(), builtinsPlugin],
  // resolve: {
  //   alias: {
  //     stream: 'stream-browserify'
  //   }
  // },
  define: {
    // 'process.env': {}
  },
})
