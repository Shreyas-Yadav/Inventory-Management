const signUpButton = document.getElementById('signUp');
const signInButton = document.getElementById('signIn');
const container = document.getElementById('container');

// Form elements
const signupForm = document.querySelector('.sign-up-container form');
const loginForm = document.querySelector('.sign-in-container form');

// API base URL (assuming the app is running on the same host)
const API_BASE_URL = window.location.origin;

// Validation functions
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

async function submitSignupForm(e) {
    e.preventDefault();
    
    // Get form inputs
    const emailInput = signupForm.querySelector('input[name="email"]');
    const passwordInput = signupForm.querySelector('input[name="password"]');
    const confirmPasswordInput = signupForm.querySelector('input[name="cnfpassword"]');
    
    // Clear previous error messages
    clearErrorMessages(signupForm);
    
    let isValid = true;
    
    // Email validation
    if (!emailInput.value.trim()) {
        showError(emailInput, 'Email is required');
        isValid = false;
    } else if (!isValidEmail(emailInput.value)) {
        showError(emailInput, 'Invalid email format');
        isValid = false;
    }
    
    // Password validation
    if (!passwordInput.value.trim()) {
        showError(passwordInput, 'Password is required');
        isValid = false;
    } else if (passwordInput.value.length < 8) {
        showError(passwordInput, 'Password must be at least 8 characters long');
        isValid = false;
    }
    
    // Confirm password validation
    if (!confirmPasswordInput.value.trim()) {
        showError(confirmPasswordInput, 'Please confirm your password');
        isValid = false;
    } else if (passwordInput.value !== confirmPasswordInput.value) {
        showError(confirmPasswordInput, 'Passwords do not match');
        isValid = false;
    }
    
    // If all validations pass, submit the form
    if (isValid) {
        try {
            const response = await fetch(`${API_BASE_URL}/register`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    email: emailInput.value,
                    password: passwordInput.value
                })
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.detail || 'Registration failed');
            }

            // Registration successful
            alert('Registration successful! Please log in.');
            container.classList.remove("right-panel-active");
        } catch (error) {
            showError(emailInput, error.message);
        }
    }
}

async function submitLoginForm(e) {
    e.preventDefault();
    
    // Get form inputs
    const emailInput = loginForm.querySelector('input[type="email"]');
    const passwordInput = loginForm.querySelector('input[type="password"]');
    
    // Clear previous error messages
    clearErrorMessages(loginForm);
    
    let isValid = true;
    
    // Email validation
    if (!emailInput.value.trim()) {
        showError(emailInput, 'Email is required');
        isValid = false;
    } else if (!isValidEmail(emailInput.value)) {
        showError(emailInput, 'Invalid email format');
        isValid = false;
    }
    
    // Password validation
    if (!passwordInput.value.trim()) {
        showError(passwordInput, 'Password is required');
        isValid = false;
    }
    
    // If all validations pass, submit the form
    if (isValid) {
        try {
            const formData = new FormData();
            formData.append('username', emailInput.value);
            formData.append('password', passwordInput.value);

            const response = await fetch(`${API_BASE_URL}/token`, {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.detail || 'Login failed');
            }

            const data = await response.json();
            // Store the access token
            localStorage.setItem('access_token', data.access_token);
            
            // Redirect or update UI to show logged-in state
            alert('Login successful!');
            // You might want to redirect to a dashboard or home page here
        } catch (error) {
            showError(emailInput, error.message);
        }
    }
}

function showError(inputElement, message) {
    // Remove any existing error messages
    const existingError = inputElement.nextElementSibling;
    if (existingError && existingError.classList.contains('error-message')) {
        existingError.remove();
    }
    
    // Create and insert error message
    const errorElement = document.createElement('div');
    errorElement.classList.add('error-message');
    errorElement.style.color = 'red';
    errorElement.style.fontSize = '0.8em';
    errorElement.style.marginTop = '5px';
    errorElement.textContent = message;
    
    // Insert error message after the input
    inputElement.parentNode.insertBefore(errorElement, inputElement.nextSibling);
}

function clearErrorMessages(form) {
    const errorMessages = form.querySelectorAll('.error-message');
    errorMessages.forEach(error => error.remove());
}

// Event listeners for form submissions
signupForm.addEventListener('submit', submitSignupForm);
loginForm.addEventListener('submit', submitLoginForm);

// Existing panel toggle functionality
signUpButton.addEventListener('click', () => {
    container.classList.add("right-panel-active");
});

signInButton.addEventListener('click', () => {
    container.classList.remove("right-panel-active");
});