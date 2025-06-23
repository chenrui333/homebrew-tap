# framework: cobra
class Dbin < Formula
  desc "Easy to use, easy to get, suckless software distribution system"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/1.6.tar.gz"
  sha256 "fa9e9d6bd3e209b755d79536f083a1c12751cb346a5c0a95337b403109841642"
  # RABRMS is not a valid SPDX-License-Identifier
  # license any_of: ["ISC", "RABRMS"]
  license "ISC"
  head "https://github.com/xplshn/dbin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7d1a78e99c83d60f8ccb1dddc890186c3f655a8befd353ae4dfe7f5b10a670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d66d071b9404e4ca6c6977795230864df476df6b32c68cb5b05d4c5aba9999"
    sha256 cellar: :any_skip_relocation, ventura:       "9671c1478bb3e5249b19c61d47a3db4f63950fd3dc3a159d42de98642df53a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b673f345d57ae2a237b9b237d73580d7f6422f03409e6a10b76287295bbc84dd"
  end

  depends_on "go" => :build

  # patch to fix ATime on macOS, upstream pr ref, https://github.com/xplshn/dbin/pull/25
  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbin --version")

    # no darwin dbin metadata in https://github.com/xplshn/dbin-metadata
    return if OS.mac?

    output = shell_output("#{bin}/dbin del bed 2>&1")
    assert_match "Failed to retrieve full name for 'bed'", output
  end
end

__END__
diff --git a/fetch.go b/fetch.go
index 27ef639..a9fbaab 100644
--- a/fetch.go
+++ b/fetch.go
@@ -18,6 +18,7 @@ import (
 	"github.com/hedzr/progressbar"
 	"github.com/jedisct1/go-minisign"
 	"github.com/pkg/xattr"
+	"github.com/xplshn/dbin/internal/util"
 	"github.com/zeebo/blake3"
 	"github.com/zeebo/errs"
 )
@@ -519,47 +520,47 @@ func downloadOCILayer(ctx context.Context, registry, repository string, manifest

 // cleanTempFiles removes .tmp files in the InstallDir that haven't been accessed in over a day.
 func cleanInstallCache(installDir string) error {
-    const oneDay = 24 * time.Hour
-    now := time.Now()
-
-    entries, err := os.ReadDir(installDir)
-    if err != nil {
-        return errFileAccess.Wrap(err)
-    }
-
-    for _, entry := range entries {
-        if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".tmp") {
-            continue
-        }
-
-        filePath := filepath.Join(installDir, entry.Name())
-        fileInfo, err := os.Stat(filePath)
-        if err != nil {
-            if verbosityLevel >= silentVerbosityWithErrors {
-                fmt.Fprintf(os.Stderr, "Error accessing file info for %s: %v\n", filePath, err)
-            }
-            continue
-        }
-        var atime time.Time
-        if sysInfo, ok := fileInfo.Sys().(*syscall.Stat_t); ok {
-            atime = time.Unix(sysInfo.Atim.Sec, sysInfo.Atim.Nsec)
-        } else {
-            if verbosityLevel >= extraVerbose {
-                fmt.Fprintf(os.Stderr, "Warning: ATime not supported for %s, skipping cleanup\n", filePath)
-            }
-            continue
-        }
-
-        if now.Sub(atime) > oneDay {
-            if err := os.Remove(filePath); err != nil {
-                if verbosityLevel >= silentVerbosityWithErrors {
-                    fmt.Fprintf(os.Stderr, "Error removing old .tmp file %s: %v\n", filePath, err)
-                }
-            } else if verbosityLevel >= extraVerbose {
-                fmt.Printf("Removed old .tmp file: %s\n", filePath)
-            }
-        }
-    }
-
-    return nil
+	const oneDay = 24 * time.Hour
+	now := time.Now()
+
+	entries, err := os.ReadDir(installDir)
+	if err != nil {
+		return errFileAccess.Wrap(err)
+	}
+
+	for _, entry := range entries {
+		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".tmp") {
+			continue
+		}
+
+		filePath := filepath.Join(installDir, entry.Name())
+		fileInfo, err := os.Stat(filePath)
+		if err != nil {
+			if verbosityLevel >= silentVerbosityWithErrors {
+				fmt.Fprintf(os.Stderr, "Error accessing file info for %s: %v\n", filePath, err)
+			}
+			continue
+		}
+		var atime time.Time
+		if sysInfo, ok := fileInfo.Sys().(*syscall.Stat_t); ok {
+			atime = util.ATime(sysInfo)
+		} else {
+			if verbosityLevel >= extraVerbose {
+				fmt.Fprintf(os.Stderr, "Warning: ATime not supported for %s, skipping cleanup\n", filePath)
+			}
+			continue
+		}
+
+		if now.Sub(atime) > oneDay {
+			if err := os.Remove(filePath); err != nil {
+				if verbosityLevel >= silentVerbosityWithErrors {
+					fmt.Fprintf(os.Stderr, "Error removing old .tmp file %s: %v\n", filePath, err)
+				}
+			} else if verbosityLevel >= extraVerbose {
+				fmt.Printf("Removed old .tmp file: %s\n", filePath)
+			}
+		}
+	}
+
+	return nil
 }
diff --git a/internal/util/atime_darwin.go b/internal/util/atime_darwin.go
new file mode 100644
index 0000000..44c5b98
--- /dev/null
+++ b/internal/util/atime_darwin.go
@@ -0,0 +1,13 @@
+//go:build darwin
+
+package util
+
+import (
+	"syscall"
+	"time"
+)
+
+// ATime returns the access time stored in Stat_t on macOS.
+func ATime(st *syscall.Stat_t) time.Time {
+	return time.Unix(int64(st.Atimespec.Sec), int64(st.Atimespec.Nsec))
+}
diff --git a/internal/util/atime_unix.go b/internal/util/atime_unix.go
new file mode 100644
index 0000000..48cfb6e
--- /dev/null
+++ b/internal/util/atime_unix.go
@@ -0,0 +1,13 @@
+//go:build !darwin
+
+package util
+
+import (
+	"syscall"
+	"time"
+)
+
+// ATime returns the access time stored in Stat_t on Linux/BSD.
+func ATime(st *syscall.Stat_t) time.Time {
+	return time.Unix(int64(st.Atim.Sec), int64(st.Atim.Nsec))
+}
