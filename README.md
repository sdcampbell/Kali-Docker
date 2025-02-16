# Kali-Docker
My customized Kali Docker container with my tools and customizations. This allows me to quickly spin up a recon and web app testing container anywhere.

## Build or update

```
bash update.sh
```

## Run

```
docker run --rm -it -v /opt/wordlists:/wordlists -v $(pwd):/data -e CHAOS_KEY=redacted kali
```
