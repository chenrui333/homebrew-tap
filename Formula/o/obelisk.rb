class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.39.4.tar.gz"
  sha256 "f8f332728a15fcaf28201570160642464e53dba3127041fabeca3ee4d9f97d3b"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12d8e72962d1c3eed8c53010321cf53a7d3f411f676efcd2b62a3317107c2764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e586f62e1f41273a1d4a75c13fcd070c381fd0bb73392ecb74cf9a33c880c9dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a5ee9cd2a5a4f3894d57ff3e3d7cb03b1e8c7bf6d666228640a864da532473"
    sha256 cellar: :any,                 arm64_linux:   "cc788e0b2d09ee05097419ce0cee68d0fa472b346f64fecb57f2e6a21c921546"
    sha256 cellar: :any,                 x86_64_linux:  "d9dced5570896b831214b257077f7ef8f2171f242ce3756ece53bf84be7910ce"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
