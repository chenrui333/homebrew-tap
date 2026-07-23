class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "16ccf3bfb5410e7a27a54e8a98688e0f5981aebef02b5f280cd588555a2d907a"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18835936c33b3ac5e8e468451189977c4e6f34c21dcf1d0ff6374a6292632080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "251a180f6c88e361e5f4311f20766f0a359e4874eb72a9e5a1201dfc6f715eec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f213a2492a917c21536c81efe96335766bda1d1459c8a58302a5614a950d8140"
    sha256 cellar: :any,                 arm64_linux:   "ee9a9b6c5ced321dcc9d16f897063c7aad0edfe7352c4efa6991d5d9913606e8"
    sha256 cellar: :any,                 x86_64_linux:  "c839e9edac95c3e5b18b932c0824a76db7166361390b1914cf3905d618cb5cb6"
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
