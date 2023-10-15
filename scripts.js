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

// Function to handle download
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

// Function to handle print
function printFunction() {
    hideButtons();
    window.print();
    showButtons();
}
