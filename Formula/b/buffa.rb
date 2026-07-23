class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "16ccf3bfb5410e7a27a54e8a98688e0f5981aebef02b5f280cd588555a2d907a"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c55cf1e6c6f0d03431508fa2137c03a17e98629572a6ee779c5b6198bc92af96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ba6ea3cdffd2d185bd36af253ffb4c30946ac4bcceb536a6065b229e5cc7042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b8231f3ea94334ace97745a1c09422cfc69ed97a63bf3278d880f5574e7ca4d"
    sha256 cellar: :any,                 arm64_linux:   "faec5fdc31a875de9ab89519eed2c871bbdeaf5026718505b399017b1016af4d"
    sha256 cellar: :any,                 x86_64_linux:  "a6e764773de36d25067c2516b97838af422419c8372ac3c61ce7c60fc9d1d7c9"
  end

  depends_on "rust" => :build
  depends_on "protobuf"

  def install
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa")
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa-packaging")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-buffa --version")

    (testpath/"sample.proto").write <<~PROTO
      syntax = "proto3";
      package example.v1;

      message Greeting {
        string message = 1;
      }
    PROTO

    (testpath/"gen").mkpath
    system "protoc",
           "--plugin=protoc-gen-buffa=#{bin}/protoc-gen-buffa",
           "--plugin=protoc-gen-buffa-packaging=#{bin}/protoc-gen-buffa-packaging",
           "--buffa_out=gen",
           "--buffa-packaging_out=gen",
           "sample.proto"

    assert_match "pub struct Greeting", (testpath/"gen/sample.rs").read
    assert_match "pub mod example", (testpath/"gen/mod.rs").read
  end
end
