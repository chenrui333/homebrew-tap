class Nastro < Formula
  desc "Record and transcribe audio locally"
  homepage "https://github.com/scaccogatto/nastro"
  url "https://github.com/scaccogatto/nastro/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "1d77d721a0e1b25ae37cef73414f53b08bc0c1f12870980872f05360b77e822c"
  license "MIT"
  head "https://github.com/scaccogatto/nastro.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9978b1b56470112f6c92a8b46aa5a677ed8452a1f96f8b05ee5383a9884bc246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03bec460637e9de2d3f023062df38a86c765d6d17b059380a0d82c70efd34bcb"
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
