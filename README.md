# Mopidy on a container

[Mopidy is an extensible music server written in Python.](https://github.com/mopidy/mopidy)

Mopidy plays music from local disk, Spotify, SoundCloud, Google Play Music, and more. You edit the playlist from any phone, tablet, or computer using a range of MPD and web clients.

# Streaming to Icecast

# Streaming to Snapcast

To stream to snapcast you don't have to change anything, but the following code in the `mopidy.conf` is responsible for the streaming

```
[audio]
output = audioresample ! audio/x-raw,rate=48000,channels=2,format=S16LE ! audioconvert ! wavenc ! filesink location=/output/snapfifo
```

