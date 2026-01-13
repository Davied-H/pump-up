/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // 品牌色 - 从 iOS App 提取
        primary: {
          DEFAULT: '#D4FF00',
          50: '#F7FFE6',
          100: '#EFFFCC',
          200: '#E5FF99',
          300: '#DCFF66',
          400: '#D4FF00',
          500: '#B8E600',
          600: '#9CCF00',
          700: '#80B800',
          800: '#669900',
          900: '#4D7300',
        },
        // 深色主题色
        dark: {
          DEFAULT: '#000000',
          50: '#2C2C2E',
          100: '#1C1C1E',
          200: '#161618',
          300: '#0D0D0F',
          400: '#000000',
        },
        // 功能色
        workout: {
          strength: '#9333EA',
          cardio: '#22C55E',
          hiit: '#F97316',
          yoga: '#06B6D4',
          flexibility: '#EC4899',
          outdoor: '#EAB308',
        },
        meditation: {
          sleep: '#6366F1',
          stress: '#EC4899',
          focus: '#3B82F6',
          breathing: '#14B8A6',
          morning: '#F97316',
          gratitude: '#A855F7',
        },
      },
      fontFamily: {
        sans: ['DM Sans', 'system-ui', 'sans-serif'],
        heading: ['Space Grotesk', 'system-ui', 'sans-serif'],
      },
      borderRadius: {
        '4xl': '2rem',
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-out',
        'slide-up': 'slideUp 0.5s ease-out',
        'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { opacity: '0', transform: 'translateY(20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
      },
    },
  },
  plugins: [],
}
