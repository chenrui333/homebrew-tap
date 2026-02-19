class Kyanos < Formula
  desc "Networking analysis tool using eBPF"
  homepage "https://kyanos.io/"
  url "https://github.com/hengyoush/kyanos/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "832976e747eeb6c86fb0fb1e031eeb3a6d3d020dc998c214cb8a31ffac5f4b08"
  license "Apache-2.0"
  head "https://github.com/hengyoush/kyanos.git", branch: "main"

  depends_on "go" => :build
  depends_on "libbpf"
  depends_on :linux

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Upstream expects generated eBPF objects to exist before `go build`.
    system "make", "build-bpf"

    ldflags = %W[
      -s -w
      -X kyanos/version.Version=#{version}
      -X kyanos/version.CommitID=#{tap.user}
      -X kyanos/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyanos --version")
  end
end
