class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0a9891411bef567baea10df68a35cbd783b6e4d3da6853ca09a97ac044bb225a"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd07f68813afc0671d96e0a80029558f82add983741280d5354627bfe49da5ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "562cdce362087697040388608f0b128547a8d7ed8c814abc2735cea00f434576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a02667a58373e4c2f5fd671224ecc93a6830998d89429a693c148ff2954d988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec1df080e8cbfb672e93a324e4f7a1f0eea6e82d93fd5557b55995df81ba478f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03899d872cb324dcbd7aaf1c5258010e476792559f52c7a8007f7cb9f3a93f77"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
