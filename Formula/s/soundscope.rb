class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9b46af6c745aae4ca064a659b660d60a35df2d39a76ac6d8db82e971e199862f"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be0ec35dc37086f18170c677baf5657e03539ea3503fbb0ab5b13a31bf314fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5725d010ec3bc48a9249f7603bb80485e941b42be4c081ed5ad9d38f4a0f4a1f"
    sha256 cellar: :any_skip_relocation, ventura:       "fcd9aa3c5894ecbffda7463c8cd0b24cf4d7df35d4bdb9782e30aa92ed780a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36597380c061c3356ab24e24b28cd34eb598f538c1d8be63ae3acdbd5c4d90c9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Skip this part of the test on Linux because `cannot find card '0'` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"soundscope", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "632.46Hz", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
