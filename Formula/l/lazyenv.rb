class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "268b45242814680eb541f68f7289b43ea710d35b3b20dbad5b70f1ae26fbbd56"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "571fd5c3ab9db50d030cb2e895711cb29cebaedc77a3a7a16de674e27fb07c31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571fd5c3ab9db50d030cb2e895711cb29cebaedc77a3a7a16de674e27fb07c31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f308bb18e7b15fc27da7da24da749c63498bbe66f863c74ddb3b7e45db49ca1"
    sha256 cellar: :any,                 x86_64_linux:  "8a3af48c132a9ed5b271f5956c07f7597d482ac9462c56cbd4a1e3d732e6a72f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyenv --version 2>&1")
  end
end
