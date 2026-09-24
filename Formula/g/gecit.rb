class Gecit < Formula
  desc "DPI bypass tool using fake TLS ClientHello packets"
  homepage "https://github.com/boratanrikulu/gecit"
  url "https://github.com/boratanrikulu/gecit/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a31ebb62041a66eb01191585be3ef3e618803c3759b5ffd5767a285eab3ca020"
  license "GPL-3.0-only"
  head "https://github.com/boratanrikulu/gecit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9cfda35f778fc05e3f37ba4fa03612470d8fe35c743052bff4c780dd2b3eadf6"
    sha256 cellar: :any,                 x86_64_linux: "b7bcf94cd870d78596efbecf36bfa18872e30fa9eb946caf05c2a6a753f6c77d"
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
