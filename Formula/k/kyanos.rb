class Kyanos < Formula
  desc "Networking analysis tool using eBPF"
  homepage "https://kyanos.io/"
  url "https://github.com/hengyoush/kyanos/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "e772c20bde365db42b57c3344ff3257a2292b74b96acb19be20f2f8719a0f3bf"
  license "Apache-2.0"
  head "https://github.com/hengyoush/kyanos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "9818ca3bd1dd925b523d0390e1b64758a6caa5afd379de620308a62377b547a9"
    sha256 cellar: :any, x86_64_linux: "4b857fad1fd84e948961c665a042371f69113ec17b0eb8ff0195eacd297d859b"
  end

  depends_on "go" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib-ng-compat"

  resource "libbpf" do
    url "https://github.com/libbpf/libbpf/archive/e0554200338152aa5c9ffe635a5c312a0a0e86dc.tar.gz"
    sha256 "1726ab89357fb41b575680e010f37f6ac1c3329c43aba63f9901fa8aea06d300"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.prepend_path "PATH", formula_opt_bin("llvm")

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Upstream expects generated eBPF objects to exist before `go build`.
    resource("libbpf").stage buildpath/"libbpf"
    system "make", "build-bpf", "CLANG=#{formula_opt_bin("llvm")/"clang"}"

    ldflags = %W[
      -s -w
      -X kyanos/version.Version=#{version}
      -X kyanos/version.CommitID=#{tap.user}
      -X kyanos/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/kyanos version 2>&1")
    output = shell_output("#{bin}/kyanos watch http --not-a-real-option 2>&1")
    assert_match "not-a-real-option", output
  end
end
