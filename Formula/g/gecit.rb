class Gecit < Formula
  desc "DPI bypass tool using fake TLS ClientHello packets"
  homepage "https://github.com/boratanrikulu/gecit"
  url "https://github.com/boratanrikulu/gecit/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "f725aae8548d6e198c3eee513199128cdbc30d1bc92eea37b32f3a2fa9a4d17e"
  license "GPL-3.0-only"
  head "https://github.com/boratanrikulu/gecit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "671a94e33a19bb5f3f504e5072667cbaa04568bdff8256b8e914dcd58fb02c21"
    sha256 cellar: :any,                 x86_64_linux: "d73fe4264d3b67257bd63da8523b0a59a1c4aaf2caebe57ba8126664367df0ed"
  end

  depends_on "go" => :build
  depends_on "libbpf" => :build
  depends_on "llvm" => :build
  depends_on :linux

  def install
    ENV.prepend_path "PATH", formula_opt_bin("llvm")
    ENV.prepend_path "CPATH", formula_opt_include("libbpf")

    system "go", "run", "github.com/boratanrikulu/gobee/cmd/gobee", "translate",
           "--bindings-dir", "pkg/ebpf/bpf", "pkg/ebpf/bpf/src"
    inreplace "pkg/ebpf/bpf/src/sockops.bpf.c", "struct ConnState state;", "struct ConnState state = {0};"
    system "make", "-C", "pkg/ebpf/bpf/src", "bpf-all"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gecit"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gecit", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
