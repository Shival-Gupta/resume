function downloadFunction() {
    const element = document.getElementById('body');
    const formattedDate = new Date().toLocaleDateString('en-GB').replace(/\//g, '-');
    const options = {
        margin: 10,
        filename: 'Shival_Gupta_Resume_' + formattedDate + '.pdf',
        image: { type: 'jpeg', quality: 1.0 }, // Use a higher quality JPEG
        html2canvas: { scale: 4 }, // Increase the scale for high resolution
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    html2pdf(element, options);
}

function printFunction() { 
    window.print(); 
}
