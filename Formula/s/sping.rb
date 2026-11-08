class Sping < Formula
  desc "Real-time connectivity monitor with network diagnostics"
  homepage "https://github.com/LambdaBytes/sping"
  url "https://github.com/LambdaBytes/sping/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "ba8508109bab003b5d5fd3333f188ab4ecb46a2d281ef78767fbea7c4a6a8ad4"
  license "MIT"
  head "https://github.com/LambdaBytes/sping.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ae72ee3420e88ae6ca3e820601d2a38d44261dd6cad4f29cea64d1ac70cd86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79154804fb722ec685508d7b22bcd705ae579e61dded7e40c10c6506b5ef1ba9"
    sha256 cellar: :any,                 arm64_linux:   "49da3b578c552289190a95032ad56cfcb2a92fdc2a6d5b26bcfc92bcdd632788"
    sha256 cellar: :any,                 x86_64_linux:  "ebf7aff0215e3f81ac80fa02eb993405c2411c09a366e76f52e73f5f32a8f801"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["SPING_ASSETS_DIR"] = buildpath/"assets"
    system "cargo", "install", *std_cargo_args
    man1.install "assets/man/sping.1"
    bash_completion.install "assets/completions/sping.bash" => "sping"
    fish_completion.install "assets/completions/sping.fish"
    zsh_completion.install "assets/completions/_sping"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sping --version")
    (testpath/"targets").write "# No targets configured\n"
    output = shell_output("#{bin}/sping --batch #{testpath}/targets 2>&1", 2)
    assert_match "contains no targets", output
    output = shell_output("#{bin}/sping 127.0.0.1 --source invalid 2>&1", 2)
    assert_match "invalid source IP address: 'invalid'", output
  end
end
