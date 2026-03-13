class SpiffeSpike < Formula
  desc "Lightweight secrets store using SPIFFE as its identity control plane"
  homepage "https://spike.ist/"
  url "https://github.com/spiffe/spike/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6cc31ed9b8b9890e83deb280065ed5d247562aab6b7e88e659bd66548ced5b4a"
  license "Apache-2.0"
  head "https://github.com/spiffe/spike.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5692410c7b18eff28856aa4b2d68ff9bf082c792eb5e6642e95c8c9debc7823e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9dae4b3b409709615b48439c41f222ff1cd9772373498b58deec0ddb4f84e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1784fd98b7888101a9c7645d3b70fb0e940902b155460d744df946fc6b6a36fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e075f7812922178ca476ccadd847d6e0bd5cc94a3504e1528295630dd118f8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420e6e596dcd1a2f77800cce9e3b6bc80a0b009587b27c677c95966e424b1927"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite"

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
