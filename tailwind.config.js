/** @type {import('tailwindcss').Config} */
export default {
  safelist: [
    {
      pattern: /max-w-*/,
    }
  ],
  content: [
    // "./index.html",
    "./src/**/*.{html,jsx}",
    "./node_modules/@nextui-org/theme/dist/**/*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["'Red Hat Display'", 'sans-serif'],
        header: ["'Unbounded'", 'sans-serif'],
      },
      colors: {
        background: {
          DEFAULT: '#FAFAFA',
          '50': '#f5f6f8',
          '100': '#eceef2',
          '200': '#d6dae1',
          '300': '#b1bac8',
          '400': '#8796a9',
          '500': '#68798f',
          '600': '#536176',
          '700': '#444f60',
          '800': '#3b4351',
          '900': '#343a46',
        },
        dark: {
          DEFAULT: '#1a1a1a',
          '50': '#f6f6f6',
          '100': '#F0F0F0',
          '200': '#d1d1d1',
          '300': '#b0b0b0',
          '400': '#888888',
          '500': '#6d6d6d',
          '600': '#5d5d5d',
          '700': '#4f4f4f',
          '800': '#454545',
          '900': '#3d3d3d',
          '950': '#1a1a1a',
        },
        primary: {
          DEFAULT: '#AEF964',
          '50': '#f1fce9',
          '100': '#ECFBD7',
          '200': '#E2FAC3',
          '300': '#E2FAC3',
          '400': '#D0F89C',
          '500': '#C7F78A',
          '600': '#AEF964',
          '700': '#95F734',
          '800': '#2d5d17',
          '900': '#144B01',
          '950': '#143209',
        },
        secondary: {
          DEFAULT: '#00fed1',
          '50': '#e7fffa',
          '100': '#c6fff0',
          '200': '#92ffe6',
          '300': '#4dffdf',
          '400': '#00fed1',
          '500': '#00e8bd',
          '600': '#00be9c',
          '700': '#009882',
          '800': '#007868',
          '900': '#006256',
          '950': '#003833',
        },
        accent: {
          DEFAULT: '#efa286',
          '50': '#fdf6f3',
          '100': '#fceae4',
          '200': '#fadace',
          '300': '#f5bfac',
          '400': '#efa286',
          '500': '#e27851',
          '600': '#ce5d34',
          '700': '#ad4b28',
          '800': '#8f4125',
          '900': '#773b25',
          '950': '#401c0f',
        },
        success: {
          DEFAULT: '#3db000',
          '50': '#f2ffe5',
          '100': '#e1ffc7',
          '200': '#c3ff95',
          '300': '#99ff57',
          '400': '#78f629',
          '500': '#54dc06',
          '600': '#3db000',
          '700': '#308605',
          '800': '#2a690b',
          '900': '#24590e',
          '950': '#0e3201',
        },
        warning: {
          DEFAULT: '#E4B00E',
          '50': '#fdfbe9',
          '100': '#fcf8c5',
          '200': '#fbee8d',
          '300': '#f8dc4c',
          '400': '#f3c611',
          '500': '#e4b00e',
          '600': '#c4880a',
          '700': '#9d610b',
          '800': '#824d11',
          '900': '#6e3f15',
          '950': '#402008',
        },
        error: {
          DEFAULT: '#F64C4C',
          '50': '#fef2f2',
          '100': '#ffe1e1',
          '200': '#ffc8c8',
          '300': '#ffa2a2',
          '400': '#fd6c6c',
          '500': '#f64c4c',
          '600': '#e31f1f',
          '700': '#bf1616',
          '800': '#9e1616',
          '900': '#831919',
          '950': '#470808',
        },
      },
      fontSize: {
        '7xl': '5rem',
        '8xl': '6rem',
        '9xl': '7rem',
      },
      maxWidth: {
        '8xl': '90rem',
        '9xl': '100rem',
      }
    },
  },
  // darkMode: 'class',
  // eslint-disable-next-line no-undef
  plugins: [require("daisyui"), require('tailwindcss-animated')],
  daisyui: {
    themes: [
      {
        mytheme: {
          primary: '#AEF964',
          "primary-light": "#BAE380",
          "base-100": "#FFFFFF",
        }
      }
    ]
  }
}

