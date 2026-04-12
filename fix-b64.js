const fs = require('fs');
['sumter-sc-landfill-guide.html','darlington-county-landfill-guide.html'].forEach(f => {
  const raw = fs.readFileSync(f, 'utf8').trim();
  try {
    const decoded = Buffer.from(raw, 'base64').toString('utf8');
    if (decoded.includes('<!DOCTYPE')) {
      // Add GTM while we're at it
      const gtm = `\n  <!-- Google Tag Manager -->\n  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':\n  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],\n  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=\n  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);\n  })(window,document,'script','dataLayer','GTM-ND932PHQ');</script>\n  <!-- End Google Tag Manager -->`;
      const fixed = decoded.replace(/<head>/i, '<head>' + gtm);
      fs.writeFileSync(f, fixed);
      console.log('FIXED + GTM: ' + f);
    } else {
      console.log('NOT BASE64: ' + f);
    }
  } catch(e) { console.log('ERROR: ' + f + ' - ' + e.message); }
});
