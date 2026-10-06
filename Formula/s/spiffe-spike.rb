class SpiffeSpike < Formula
  desc "Lightweight secrets store using SPIFFE as its identity control plane"
  homepage "https://spike.ist/"
  url "https://github.com/spiffe/spike/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6cc31ed9b8b9890e83deb280065ed5d247562aab6b7e88e659bd66548ced5b4a"
  license "Apache-2.0"
  head "https://github.com/spiffe/spike.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "542a9b235ea752191ed47542a25b0b1e9ec3a3c27fb48a741b39af2615e5e59a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f89cdc0c16ea69f2bd746639fdd187554bddd1e6a497cb0ef734e3d30a8de6"
    sha256 cellar: :any,                 arm64_linux:   "e2987758639d695b22a24d5155c16005cfc08370bccf4f028abac43df27f926d"
    sha256 cellar: :any,                 x86_64_linux:  "8942cea5879e5345a1ebc9dde629ec7291f685547bbfa69980e4cace8a2e8742"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # cgo for sqlite dependency
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["GOFIPS140"] = "v1.0.0"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    %w[keeper nexus spike].each do |cmd|
      ldflags = "-s -w"
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./app/#{cmd}/cmd/main.go"
    end
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"keeper", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "SPIKE: Secure your secrets with SPIFFE", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
