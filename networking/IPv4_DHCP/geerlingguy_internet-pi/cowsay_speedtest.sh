while sleep 600; do \
	curl -s http://127.0.0.1:9798/metrics | \
	grep -E '(speedtest_upload_bits_per_second|speedtest_download_bits_per_second)' | \
	cowsay -f tux | \
	lolcat --force --spread 1.0;
done;
