// src/scripts/init-mermaid.js
import mermaid from 'mermaid';

// Basic configuration (can be customized)
const config = {
  startOnLoad: false, // We'll explicitly call run(), so disable this
  // Add other Mermaid options here if needed
  theme: 'dark', // Explicitly set a theme (options: default, dark, forest, neutral)
};

mermaid.initialize(config);

// Wait for the DOM to be fully loaded before running Mermaid
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM fully loaded. Running Mermaid...');
  try {
    mermaid.run({
      nodes: document.querySelectorAll('pre.mermaid'),
    });
    console.log('Mermaid run completed.');
  } catch (error) {
    console.error('Error running Mermaid:', error);
  }
});

console.log('Mermaid script loaded, waiting for DOMContentLoaded.'); // Update log
