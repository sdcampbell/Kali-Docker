# Kali-Docker
My customized Kali Docker container with my tools and customizations. This allows me to quickly spin up a recon and web app testing container anywhere.

## Build

```
docker run --rm -it -v /opt/wordlists:/wordlists -v $(pwd):/output -e CHAOS_KEY=redacted kali
```
