import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import { nodePolyfills } from 'vite-plugin-node-polyfills'
import builtins from 'rollup-plugin-node-builtins'
import mkcert from'vite-plugin-mkcert'

const builtinsPlugin = builtins({
  crypto: true,
})


export default defineConfig({
  plugins: [
    react(), 
    nodePolyfills(), 
    builtinsPlugin,
    // mkcert()
  ],
  // resolve: {
  //   alias: {
  //     stream: 'stream-browserify'
  //   }
  // },
  define: {
    // 'process.env': {}
  },
})
