import { defineConfig } from 'vitepress';

const sharedLinks = [
  { text: 'Installation', link: '/installation' },
  { text: 'Configuration', link: '/configuration' },
  { text: 'Usage', link: '/usage' },
  { text: 'CLI', link: '/cli' },
  { text: 'Examples', link: '/examples' }
];

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: '/gitlab/',
  title: 'gitlab ruby gem',
  description: 'Ruby client and CLI for GitLab API',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' }
    ].concat(sharedLinks),
    sidebar: [
      { items: sharedLinks }
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/NARKOZ/gitlab' }
    ],
    footer: {
      message: 'Released under the <a href="https://github.com/NARKOZ/gitlab/blob/master/LICENSE.txt" target="_blank">BSD 2-clause license</a>.',
      copyright: 'Copyright &copy; 2012-present <a href="https://github.com/NARKOZ" target="_blank">Nihad Abbasov</a>'
    },
    editLink: {
      pattern: 'https://github.com/NARKOZ/gitlab/edit/master/docs/:path',
      text: 'Edit this page on GitHub'
    },
    lastUpdated: {
      text: 'Updated at',
      formatOptions: {
        dateStyle: 'full',
        timeStyle: 'medium'
      }
    },
    externalLinkIcon: true
  }
});
