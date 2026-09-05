class Nastro < Formula
  desc "Record and transcribe audio locally"
  homepage "https://github.com/scaccogatto/nastro"
  url "https://github.com/scaccogatto/nastro/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "50e4da6b32a7cfec3d1063f79578fd7cae2ce8265fcec0e9f8288c6213979b00"
  license "MIT"
  head "https://github.com/scaccogatto/nastro.git", branch: "main"

  depends_on "go" => :build
  depends_on xcode: :build
  depends_on :macos
  depends_on macos: :sonoma
  depends_on "whisper-cpp"

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "14.4"
    system "go", "build", *std_go_args
    system "swiftc", "-O", "-framework", "CoreAudio", "-framework", "AVFoundation",
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
  end
end
