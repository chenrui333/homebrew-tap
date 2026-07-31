class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "070eb2e500a1c25cf281cc1c1bcfdfa7c8e0d6f4e117e5473f1ca23210458184"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38c531c4fc221868821fa16c491ed6029f6c690da3fa2d7e53b3c97ac854fa7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b0a5d3637bc170f10e466d1e43b5ab13d73d6ccba7ccac35fdefbb3c6625e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a78f6e96c09803d6be6603dc73988bd5c47ac07d23ed01699e07cfa1c2d11c61"
    sha256 cellar: :any,                 arm64_linux:   "448ac1b79c5a51dbdce534064aef42286dd59843cf34d48f98acc0c36a16fed3"
    sha256 cellar: :any,                 x86_64_linux:  "ca45a8a04ec04eedc95f1be9e4f73c291562cc1d0527323fe9c90ac20d1d297f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/clickhousectl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clickhousectl --version")

    output = shell_output("#{bin}/clickhousectl cloud auth status")
    assert_match "Not configured", output
  end
end
