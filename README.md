# John Burbridge - Personal Website

## Overview
This is the personal website for John Burbridge, a DevEx Engineering Consultant and founder of Spiral House.

## Adding Your LinkedIn Profile Picture

1. Save your LinkedIn profile picture to the project directory (recommended filename: `profile.jpg` or `profile.png`)

2. Update the CSS in `styles.css` by replacing the `.image-placeholder` with:

```css
.image-placeholder {
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background-image: url('profile.jpg'); /* Update this with your image filename */
    background-size: cover;
    background-position: center;
    border: 4px solid var(--accent);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}

/* Remove this style once you add your image */
.image-placeholder::after {
    display: none;
}
```

## Deployment
This website is set up to be deployed on GitHub Pages with the custom domain johnburbridge.com.

### How to deploy
1. Initialize git repository if you haven't already: `git init`
2. Commit all files: `git add . && git commit -m "Initial commit"`
3. Create a repository on GitHub
4. Push to GitHub: `git remote add origin [your-repo-url] && git push -u origin main`
5. Enable GitHub Pages in your repository settings (Settings > Pages)
6. Configure your domain's DNS settings to point to GitHub Pages

## Structure
- `index.html` - Main HTML content
- `styles.css` - All styling
- `script.js` - JavaScript for navigation and smooth scrolling
- `CNAME` - For GitHub Pages custom domain configuration
