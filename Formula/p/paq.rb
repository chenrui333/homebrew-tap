class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "d1e1274f4ee229580947850de4d8f6e0f2eaafda478130a045e95af2b6b40b75"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957081f3256d67af6d2432f2b4c56913a61b56d72e611c79ec183ab5fac72356"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01acbb40c13f4cc28f6636dfaf7a1004e425178a46f97e2a4acf31d46ea6f086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02b1408d520932124d658c3b78587237a7ad27da2cb52b7c9ffd98edfd04ae19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fed8c36abfd87562a42685ef2ed9b18545bf562ce5430ee70654e6338dc55005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5f1c1894965d8e6e2d5c3a0fdf2fe2aafc257deeea4a23c5fd34d2f94d271d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "eb9122ffff587d1cb9e56682d68a637e8efaa6c0cd3db5d90da542d1ce0bd2c2", output
  end
end
