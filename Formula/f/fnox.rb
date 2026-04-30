class Fnox < Formula
  desc "Encrypted/remote secret manager"
  homepage "https://github.com/jdx/fnox"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "dd0c26925dc439b187aa38613e564f455c01f3122e6a6f7c5bf24ed9fd05efbc"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnox --version")
    assert_match "fnox", shell_output("#{bin}/fnox doctor 2>&1", 1)
  end
end
