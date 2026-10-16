class Scope < Formula
  desc "Serial monitor with scripting support"
  homepage "https://github.com/matheuswhite/scope-rs"
  url "https://github.com/matheuswhite/scope-rs/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "7f4b4ff43ac211c21b3bd8beda23d1a7dc5286c6b6629797490900b792bd6a03"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/matheuswhite/scope-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7adaf37f31ae3d69e410a6b8b266162e3a6494f939e944b42b2ecfecdd56eb7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d9f91977e1cf002b580f06aa78754aade55f398a13ee5a288980522b3c9024"
    sha256 cellar: :any,                 arm64_linux:   "5b34fd1f982ef3d8b963ee3ae8ce9c6fb4c4cb6f85bf82e7c20b046c086e0302"
    sha256 cellar: :any,                 x86_64_linux:  "d26d6d9ee58d3e0980679fce1d2b6badb7f704d6e6e2e92d354fe84584b49f84"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "systemd"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"scope", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scope --version")
    output = shell_output("#{bin}/scope --name '' list 2>&1", 1)
    assert_match "session name cannot be empty", output
  end
end
