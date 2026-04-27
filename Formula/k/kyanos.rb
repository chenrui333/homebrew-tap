class Kyanos < Formula
  desc "Networking analysis tool using eBPF"
  homepage "https://kyanos.io/"
  url "https://github.com/hengyoush/kyanos/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "832976e747eeb6c86fb0fb1e031eeb3a6d3d020dc998c214cb8a31ffac5f4b08"
  license "Apache-2.0"
  head "https://github.com/hengyoush/kyanos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3891d9a99a02dfdbe32cc44447121dc2cee3770a6650104e0da823ea22f95ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7034d462c2beb91ffd92afab35e5203694c6b51c38671b16fb2c3c8478f2e328"
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

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Upstream expects generated eBPF objects to exist before `go build`.
    resource("libbpf").stage buildpath/"libbpf"
    system "make", "build-bpf", "CLANG=#{Formula["llvm"].opt_bin/"clang"}"

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
    assert_match "Filter HTTP messages based on method", shell_output("#{bin}/kyanos watch http --help 2>&1")
  end
end
