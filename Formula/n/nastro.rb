class Nastro < Formula
  desc "Record and transcribe audio locally"
  homepage "https://github.com/scaccogatto/nastro"
  url "https://github.com/scaccogatto/nastro/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "50e4da6b32a7cfec3d1063f79578fd7cae2ce8265fcec0e9f8288c6213979b00"
  license "MIT"
  head "https://github.com/scaccogatto/nastro.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebceeabd88294014ddce5f6580ff5cf363757a37a9a8271896f1f9d79882927f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a40165c5a7570706c449dfd7a50adf5a4a8bbc1f767579a26bfe5d5ed48fb4d7"
  end

  depends_on "go" => :build
  depends_on xcode: ["15.3", :build]
  depends_on :macos
  depends_on "whisper.cpp"

  on_macos do
    depends_on macos: :sonoma
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "14.4"
    system "go", "build", *std_go_args
    system "swiftc", "-O", "-target", "#{Hardware::CPU.arch}-apple-macosx14.4",
           "-framework", "CoreAudio", "-framework", "AVFoundation",
           "-framework", "AudioToolbox", "-framework", "AppKit", "-framework", "CoreGraphics",
           "-o", bin/"nastro-tap", "tap/main.swift"
  end

  def caveats
    <<~EOS
      Audio recording requires macOS 14.4 or newer and permission for
      your terminal under Screen & System Audio Recording.
    EOS
  end

  test do
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/nastro transcribe 2>&1", 1)
    assert_match "usage: nastro transcribe <id|last>", output
    assert_path_exists bin/"nastro-tap"

    recording = testpath/"Recordings/nastro/2026-01-02-0304-standup"
    recording.mkpath
    (recording/"metadata.json").write '{"duration_seconds": 65}'
    (recording/"transcript.txt").write "hello"
    assert_match "2026-01-02-0304-standup\t2026-01-02 03:04\tstandup\t01:05",
                 shell_output("#{bin}/nastro records --plain")
  end
end
