class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "62e87ada5d4fe2828dc49cf764256a6451a20700a3e98494ad5206f3b43b4e93"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "392c53156b35c3557b8e7d570a14954d1a221e60b9c1058f1eef1601f925d4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c66a3513a011904c9ede787afe15248f597b2b99188c1f1a1ae41f9c976cf22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ccd65d3214a248f61f3e85c145d0af63420c6edff7f24baeead6c0622be3b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a5122287c330d0ad785fcf32bc0e03f13b25cb0c139e6ff204af81c862b6a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7cd095e4cee11ca54b5c4b99b42f4fbf0e147484bb257fceacf102e13028c5"
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
