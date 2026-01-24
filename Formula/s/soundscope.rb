class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9c425e836b98ca08ccf6d2988c24d3d09f285e8c15c0e6c35090af3d15c9064e"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63c4fa8dffc4218c9647cc1eda491e4abed09c16048d33e171e0ceb72f1872b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3797010db6fcb58b8f20c1338207af95fa6709960c76fbdaada98ebf5685cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99623ceb99a29b9a9b50f1db527276bbe15dd71be963128756c604b724d865dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc589d12469de76f84f99b25dc0bc679a1c998b434af58aa287037b0dcae6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b258bb57f192a36a3ea2961c99634e33f0c110f2ce891175a8e8c64d12a7602c"
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
