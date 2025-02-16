fetch('/me', {
    credentials: 'include'
})
.then(response => {
    if (!response.ok) {
        window.location.href = '/';
    }
})
.catch(() => {
    window.location.href = '/';
});


document.getElementById('logoutButton').addEventListener('click', () => {
    fetch('/logout', {
        method: 'POST',
        credentials: 'include'
    })
    .then(response => {
        if (response.ok) {
            window.location.href = '/';
        } else {
            console.error('Logout failed');
        }
    })
    .catch(error => {
        console.error('Logout error:', error);
    });
});

