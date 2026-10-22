class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a948a4fed25b905721242941730bcc04ab89cf57e6ac96a6712f247b77b6d530"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3555f6e6b8e8e7657a4f57d85c2126b42e76d58de4be3993665cb79972440e15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a9f51d982ea027765b2e49d781c0f608e2f7c4a5d1a1bef94fe8e2bd4e7a54"
    sha256 cellar: :any,                 arm64_linux:   "ffffe496dddff4d6260d1f6d8cec36c0a233e078bd5d8b9b5259a123694042d5"
    sha256 cellar: :any,                 x86_64_linux:  "c8371b06f989feef4c109070af0e21a761c2d79ec34efd24a6e5ec54a8437691"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/clickhousectl")
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/clickhousectl --version")

    output = shell_output("#{bin}/clickhousectl cloud auth status")
    assert_match "Not configured", output
  end
end
