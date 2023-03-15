> ⚠️Notice: This repository is a fork and will be force-pushed on a regular basis.

### Installation via Chocolatey

1. Add my chocolatey repository as a source
```
choco source add -n smart123s-choco -s "https://nuget.cloudsmith.io/smart123s/choco/v2/"
```

2. Install package as usual
```
choco install magisk-on-wsa
```

### Why a custom repository?
Distribution of modified versions of Microsoft (or any proprietary software) is in a legally gray are. Moreover, LSPosed no longer provides official builds via Actions artifacts in their repositories. As a result, we have to rely on unofficial builds. These two factors makes the package hardly fit the official Chocolatey Community Repository, so to not risk my account getting banned there, I've decided to self host this package for personal use.
