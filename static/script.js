document
    .getElementById("shorten-button")
    .addEventListener("click", function () {
        const urlToShorten = document.getElementById("url-input").value;

        if (!urlToShorten) {
            alert("Please enter a URL to shorten.");
            return;
        }

        const apiUrl = `https://api.tinyurl.com/create?url=${encodeURIComponent(
            urlToShorten
        )}&domain=tiny.one`;

        fetch(apiUrl, {
            method: "POST",
            headers: {
                Authorization:
                    "Bearer cz1L14CsNz0YnwDqLmNuUs7MOAU0SqtvPKmGEDWV5jtqZ6OeLNAceyafJYLt",
                "Content-Type": "application/json",
            },
        })
            .then((response) => response.json())
            .then((data) => {
                if (data.data) {
                    const shortUrl = data.data.tiny_url;
                    document.getElementById(
                        "short-url"
                    ).innerText = `Short URL: ${shortUrl}`;
                } else {
                    alert("Error shortening URL. Please try again.");
                }
            })
            .catch((error) => {
                console.error("Error:", error);
                alert("An error occurred. Please try again.");
            });
    });
