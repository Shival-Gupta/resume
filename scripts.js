// Function to hide buttons
function hideButtons() {
    document.getElementById('download-button').style.display = 'none';
    document.getElementById('print-button').style.display = 'none';
}

// Function to show buttons
function showButtons() {
    document.getElementById('download-button').style.display = 'inline-block';
    document.getElementById('print-button').style.display = 'inline-block';
}

// Function to handle print
function printFunction() {
    hideButtons();
    window.print();
    showButtons();
}

// Function to handle download (New Promise-based)
async function downloadFunction() {
    hideButtons();
    try {
        const element = document.getElementById('body');
        const formattedDate = new Date().toLocaleDateString('en-GB').replace(/\//g, '-');
        const options = {
            margin: 10,
            filename: `Shival_Gupta_Resume_${formattedDate}.pdf`,
            image: { type: 'jpeg', quality: 1.0 },
            html2canvas: { scale: 4 },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
        };
        // Create an HTML2PDF instance with the source element and options
        const pdf = new html2pdf().from(element).set(options);
        await pdf.outputPdf().save();   // Generate and save the PDF

    } catch (error) {
        console.error('PDF generation error:', error);
    } finally {
        showButtons();
    }
}

// Function to handle download (Old Monolythic-style)
/*
function downloadFunction() {
    hideButtons();
    const element = document.getElementById('body');
    const formattedDate = new Date().toLocaleDateString('en-GB').replace(/\//g, '-');
    const options = {
        margin: 10,
        filename: 'Shival_Gupta_Resume_' + formattedDate + '.pdf',
        image: { type: 'jpeg', quality: 1.0 },
        html2canvas: { scale: 4 },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };
    html2pdf(element, options);
    showButtons();
}
*/