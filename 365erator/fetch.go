package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
	"sync"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("provide a filename to work with!")
	}
	file, err := os.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	domains := strings.Split(string(file), "\n")
	var validDomains []string
	for _, domain := range domains {
		domain = strings.TrimSpace(domain)
		if domain != "" {
			validDomains = append(validDomains, domain)
		}
	}
	f, err := os.Create(os.Args[1] + "365")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	var wg sync.WaitGroup
	var mu sync.Mutex
	for _, domain := range validDomains {
		wg.Add(1)
		go func(domain string) {
			defer wg.Done()
			resp, err := http.Get("https://login.microsoftonline.com/" + domain + "/.well-known/openid-configuration")
			if err != nil {
				log.Printf("Error fetching %s: %v", domain, err)
				return
			}
			defer resp.Body.Close()

			body, err := io.ReadAll(resp.Body)
			if err != nil {
				log.Printf("Error reading response for %s: %v", domain, err)
				return
			}

			if resp.StatusCode == 200 {
				bodyStr := string(body)
				if strings.Contains(bodyStr, "sts.windows.net/") {
					parts := strings.Split(bodyStr, "sts.windows.net/")
					if len(parts) > 1 {
						tenantID := strings.Split(parts[1], "/")[0]
						mu.Lock()
						fmt.Fprintln(f, domain+","+tenantID)
						mu.Unlock()
					}
				}
			}
		}(domain)
	}
	wg.Wait()
}
