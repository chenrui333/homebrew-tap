class Pitchfork < Formula
  desc "Daemons with DX"
  homepage "https://github.com/endevco/pitchfork"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "df65c6371e555aea04095e12fad8e1035c83d749a6e8ccdfa9c2eec7a6d9ca13"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f692c80312f9ad670fa7c153b64c4011056e1d043234dc64d4e4c7061882fb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f9bf0da2f6cb51c17d2ec98abeb263384e96afb546daa7a0ac937fd11c7098a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48937ed830105dd5ccce4c04a60d2e464dac3c8b38391da3423a17ffc0dde2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94f56e703030921968caf69ebe7784bb798760eda48577ed923920f67633c12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ce4ade15ffe754a4a555d8543c8ee579a3f9ac005cc30b64d5fe4abd4248ec"
  end

  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    (testpath/"pitchfork.toml").write <<~TOML
      [daemons.test]
      run = "echo hello"
    TOML
    output = shell_output("#{bin}/pitchfork list 2>&1")
    assert_match "test", output
  end
end
