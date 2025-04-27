async function controlPump(state) {
    console.log(`Attempting to turn pump ${state}`);
    try {
        const response = await fetch(`http://localhost:8000/pump/${state}`, {
            method: 'POST'
        });
        if (!response.ok) {
            throw new Error(`Server error: ${response.statusText}`);
        }
        const data = await response.json();
        document.getElementById('status').innerText = data.message;
    } catch (error) {
        document.getElementById('status').innerText = 'Error: Could not connect to the server.';
        console.error('Fetch error:', error);
    }
}