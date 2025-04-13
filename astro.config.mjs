import { defineConfig } from 'astro/config';
import rehypeMermaid from 'rehype-mermaid';
import rehypeHighlight from 'rehype-highlight';

// Import languages directly
// (Note: Importing all might increase build time/bundle size slightly,
// but ensures they are available for registration)
import bash from 'highlight.js/lib/languages/bash';
import yaml from 'highlight.js/lib/languages/yaml';
import json from 'highlight.js/lib/languages/json';
import python from 'highlight.js/lib/languages/python';
import plaintext from 'highlight.js/lib/languages/plaintext';
import java_ from 'highlight.js/lib/languages/java'; // Use java_ to avoid keyword clash
import javascript from 'highlight.js/lib/languages/javascript';
import xml from 'highlight.js/lib/languages/xml'; // Includes html
import css from 'highlight.js/lib/languages/css';
import kotlin from 'highlight.js/lib/languages/kotlin';
import go from 'highlight.js/lib/languages/go';
import rust from 'highlight.js/lib/languages/rust';

// https://astro.build/config
export default defineConfig({
  markdown: {
    syntaxHighlight: false, // Keep default Astro (Shiki) highlighter disabled
    rehypePlugins: [
      // Add rehype-highlight BEFORE rehype-mermaid
      [
        rehypeHighlight,
        {
          // Pass languages directly for registration
          // The key is the language name used in markdown (e.g., ```python)
          // The value is the imported language definition
          languages: {
            shell: bash, // Map 'shell' alias to bash
            bash: bash,
            yaml: yaml,
            json: json,
            python: python,
            text: plaintext,
            java: java_, // Use imported java_
            javascript: javascript,
            js: javascript, // Add common alias
            html: xml, // Map html to xml
            css: css,
            kotlin: kotlin,
            go: go,
            rust: rust,
          },
          ignoreMissing: true, // Don't throw error if language not found
          // detect: true // Optionally enable auto-detection if language isn't specified
        },
      ],
      // Add rehype-mermaid
      [rehypeMermaid, { strategy: 'pre-mermaid' }],
    ],
  },
});
