class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "d39b9dfdcaa7537b51ad0af283a4c46e87f687a518657de725e68d316cbba0b9"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c6d65e796bf3122614c48f91869f6f09f7264ed97c2b82f6fefc9078e931ab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bfbef88bd4105287f8f9b9fb23e78fea9bc993f4a6247d2286c12ee631cf90d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759cd8dbf569276b98374d05f498b37fdd3681e27023453aee26a10b7af5ea15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7040494f71e9d10348312683e4a3976f383b940ba1d09e201b8862e81ad8a3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abacf1a1de275d3e1e8ea8faafc2600bc989849f8ba5224e1f21c4c6f1eda5af"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
